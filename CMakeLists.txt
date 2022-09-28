cmake_minimum_required(VERSION 3.18)
project(termux-gui-bash)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_FLAGS "-Os")
set(THREADS_PREFER_PTHREAD_FLAG ON)

set(TERMUX_PREFIX "${CMAKE_INSTALL_PREFIX}")

find_package(Threads REQUIRED)

set(version 1.0)



add_executable(termux-gui-bash-helper src/helper.c)

target_link_libraries(termux-gui-bash-helper Threads::Threads)


configure_file(src/tgui-bash.sh tgui-bash.sh @ONLY)
configure_file(src/unzip.sh tgui-bash @ONLY)
configure_file(src/docviewer.sh docviewer.sh @ONLY)

execute_process(
    COMMAND bash -c "gzip -c -k \"${CMAKE_CURRENT_BINARY_DIR}/tgui-bash.sh\" >> \"${CMAKE_CURRENT_BINARY_DIR}/tgui-bash\""
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/tgui-bash" TYPE BIN)
install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/docviewer.sh" DESTINATION "${CMAKE_INSTALL_PREFIX}/share/tgui-bash")
install(FILES
    doc_html/tutorial-light.html.gz
    doc_html/tutorial-dark.html.gz
    doc_html/manual-light.html.gz
    doc_html/manual-dark.html.gz
    DESTINATION "${CMAKE_INSTALL_PREFIX}/share/tgui-bash")
install(TARGETS termux-gui-bash-helper RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/libexec")

