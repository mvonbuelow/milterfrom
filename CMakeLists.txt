cmake_minimum_required(VERSION 3.10)

project(MilterFrom C)

find_package(PkgConfig QUIET)
pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemd_system_unit_dir DEFINE_VARIABLES prefix=${CMAKE_INSTALL_PREFIX})

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)

set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)
find_package(Milter REQUIRED)

add_executable(milterfrom src/milterfrom.c)
target_link_libraries(milterfrom PRIVATE Milter::milter Threads::Threads)

install(TARGETS milterfrom DESTINATION "${CMAKE_INSTALL_BINDIR}")
if(SYSTEMD_SYSTEM_UNIT_DIR)
	configure_file(systemd/milterfrom.service.in ${CMAKE_CURRENT_BINARY_DIR}/systemd/milterfrom.service @ONLY)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/systemd/milterfrom.service DESTINATION ${SYSTEMD_SYSTEM_UNIT_DIR})
endif()
