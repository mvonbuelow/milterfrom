cmake_minimum_required(VERSION 3.10)

project(MilterFrom C)

option(WITH_SYSTEMD "Install Systemd unit files" ON)
set(SYSTEMD_UNITDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system" CACHE PATH "Systemd unit directory")

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)

set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)
find_package(Milter REQUIRED)

add_executable(milterfrom src/milterfrom.c)
target_link_libraries(milterfrom PRIVATE ${Milter_LIBRARY} Threads::Threads)

install(TARGETS milterfrom DESTINATION "${CMAKE_INSTALL_BINDIR}")
if(NOT WIN32 AND WITH_SYSTEMD)
	configure_file(systemd/milterfrom.service.in ${CMAKE_CURRENT_BINARY_DIR}/systemd/milterfrom.service @ONLY)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/systemd/milterfrom.service DESTINATION ${SYSTEMD_UNITDIR})
endif()
