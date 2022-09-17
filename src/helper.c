#define _GNU_SOURCE

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <math.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

#include <arpa/inet.h>

#include <pthread.h>


void printUsage() {
    fputs("Usage: termux-gui.bash-helper [--main] sockname\n", stderr);
    exit(2);
}

void printError(const char* msg) {
    perror(msg);
    exit(3);
}



volatile int socket_fd = -1;
pthread_t send_thread_handle;

#define BUFFERSIZE (4096)

uint8_t in_buffer[BUFFERSIZE];


uint8_t* out_buffer = NULL;
int out_buffer_size = BUFFERSIZE;

const uint8_t separator = 30; // ASCII record separator



void read_block(int fd, void* buffer, int size) {
    int toread = size;
    while (toread > 0) {
        int ret = read(fd, buffer + (size - toread), toread);
        if (ret <= 0) {
            exit(1);
        }
        toread -= ret;
    }
}

void write_block(int fd, void* buffer, int size) {
    int towrite = size;
    while (towrite > 0) {
        int ret = write(fd, buffer + (size - towrite), towrite);
        if (ret <= 0) {
            exit(1);
        }
        towrite -= ret;
    }
}



void* send_thread(void* unused) {
    out_buffer = calloc(out_buffer_size, 1);
    if (out_buffer == NULL) {
        fputs("Could not allocate out buffer", stderr);
        exit(5);
    }
    int towrite = 0;
    while (true) {
        if (towrite >= out_buffer_size) {
            out_buffer_size *= 2;
            out_buffer = realloc(out_buffer, out_buffer_size);
            if (out_buffer == NULL) {
                fputs("Could not allocate out buffer", stderr);
                exit(5);
            }
        }
        int ret = read(0, out_buffer + towrite, 1);
        if (ret <= 0) {
            exit(1);
        }
        towrite++;
        if (out_buffer[towrite-1] == separator) {
            towrite--; // don't write the separator
            uint32_t towrite_nw = htonl(towrite);
            write_block(socket_fd, &towrite_nw, sizeof(towrite_nw));
            write_block(socket_fd, out_buffer, towrite);
            towrite = 0;
        }
    }
    return NULL;
}


int min(int a, int b) {
    if (a < b) return a;
    else return b;
}



int main(int argc, char** argv) {
    if (argc <= 1) {
        printUsage();
    }
    const bool main = strcmp(argv[1], "--main") == 0;
    if (main && argc == 2) {
        printUsage();
    }
    const char* const sockname = argv[argc-1];
    
    
    
    struct sockaddr_un adr;
    memset(&adr, 0, sizeof(adr));
    adr.sun_family = AF_UNIX;
    
    if (strlen(sockname) == 0 || strlen(sockname) >= sizeof(adr.sun_path) - 2) {
        printUsage();
    }
    
    strncpy(adr.sun_path + 1, sockname, sizeof(adr.sun_path) - 2);
    
    
    
    int server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_fd == -1) {
        printError("Could not create socket");
    }
    
    if (bind(server_fd, (const struct sockaddr*) &adr, sizeof(adr) - sizeof(adr.sun_path) + 1 + strlen(sockname)) != 0) {
        printError("Could not bind to name");
    }
    
    if (listen(server_fd, 50) != 0) {
        printError("Could not listen");
    }
    
    socket_fd = accept(server_fd, NULL, NULL);
    if (socket_fd == -1) {
        printError("Could not accept");
    }
    
    close(server_fd);
    server_fd = -1;
    
    struct ucred cred;
    cred.uid = 1;
    socklen_t len = sizeof(cred);
    if (getsockopt(socket_fd, SOL_SOCKET, SO_PEERCRED, &cred, &len) == -1) {
        printError("Could not get peer uid");
    }
    
    if (cred.uid != getuid()) {
        fprintf(stderr, "Refused connection from UID %d\n", cred.uid);
        exit(4);
    }
    
    if (main) {
        uint8_t byte = 1;
        if (write(socket_fd, &byte, 1) <= 0) exit(1);
        if (read(socket_fd, &byte, 1) <= 0) exit(1);
        if (byte != 0) {
            fputs("Protocol negotiation failed\n", stderr);
            exit(1);
        }
        if (pthread_create(&send_thread_handle, NULL, send_thread, NULL) != 0) {
            fputs("Could not create send thread\n", stderr);
            exit(3);
        }
    }
    
    
    while (true) {
        // read message size, convert to host byte order
        uint32_t size_nw;
        read_block(socket_fd, &size_nw, sizeof(size_nw));
        uint32_t size = ntohl(size_nw);
        
        
        // read message, write to stdout
        int toread = size;
        while (toread > 0) {
            int r = min(BUFFERSIZE, toread);
            read_block(socket_fd, in_buffer, r);
            write_block(1, in_buffer, r);
            toread -= r;
        }
        if (write(1, &separator, 1) <= 0) {
            exit(1);
        }
    }
    
    
    
    return 0;
}
 
