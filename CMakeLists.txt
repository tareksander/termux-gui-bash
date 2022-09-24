cmake_minimum_required(VERSION 3.18)
project(termux-gui-bash)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_FLAGS "-Os")
set(THREADS_PREFER_PTHREAD_FLAG ON)

set(TERMUX_PREFIX "${CMAKE_INSTALL_PREFIX}")

find_package(Threads REQUIRED)

set(version 1.0)


#add_custom_command(
#    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash.1.gz"
#    COMMAND gzip ARGS -f "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash.1"
#    MAIN_DEPENDENCY "${CMAKE_CURRENT_SOURCE_DIR}/tgui-bash.1"
#    VERBATIM)


#add_custom_target(gendoc ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash.1.gz")

add_executable(termux-gui-bash-helper src/helper.c)

target_link_libraries(termux-gui-bash-helper Threads::Threads)


configure_file(src/tgui-bash.sh tgui-bash @ONLY)


install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash" TYPE BIN)
install(TARGETS termux-gui-bash-helper RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/libexec")
#install(FILES "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash.1.gz" DESTINATION "${CMAKE_INSTALL_PREFIX}/man/man1/tgui-bash.1.gz")
