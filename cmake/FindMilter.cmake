# - Try to find Milter lib with pkg-config, falling back to manual search
#
# The following imported target is defined:
#
# - Milter::milter

find_package(PkgConfig QUIET)
pkg_search_module(MILTER QUIET IMPORTED_TARGET milter)

if(MILTER_FOUND)
	if(NOT TARGET Milter::milter)
		add_library(Milter::milter ALIAS PkgConfig::MILTER)
	endif()
else()
	find_path(MILTER_INCLUDE_DIRS libmilter/mfapi.h
		/usr/local/include
		/usr/include
		/opt/local/include
		/sw/local/include
		/sw/include
		NO_DEFAULT_PATH
	)
	find_library(MILTER_LINK_LIBRARIES
		NAMES "milter"
		PATHS
		~/Library/Frameworks
		/Library/Frameworks
		/usr/local/lib
		/usr/local/lib64
		/usr/lib
		/usr/lib64
		/opt/local/lib
		/sw/local/lib
		/sw/lib
	)
	if(MILTER_INCLUDE_DIRS AND MILTER_LINK_LIBRARIES)
		add_library(Milter::milter INTERFACE IMPORTED)
		set_target_properties(Milter::milter PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${MILTER_INCLUDE_DIRS}"
			INTERFACE_LINK_LIBRARIES "${MILTER_LINK_LIBRARIES}"
		)
	endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Milter
	REQUIRED_VARS MILTER_LINK_LIBRARIES MILTER_INCLUDE_DIRS
	VERSION_VAR MILTER_VERSION
)
