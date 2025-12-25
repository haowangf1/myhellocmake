cmake_minimum_required(VERSION 3.20)

################################# header section
### project and version
project(hellocmake VERSION 0.3.0)

# configure_file(
#     ${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.h.in
#     ${CMAKE_BINARY_DIR}/version.h
# )

include_directories(${CMAKE_BINARY_DIR})

### general config
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


################################# windows and linux general config
if (MSVC)
    # msvc parallel build
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")               # msbuild parallel
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /showIncludes")   # debug header include chain
    add_definitions(-DNOMINMAX)                                 # no MIN MAX
    add_definitions(-D_WIN32_WINNT=0x0A00)                      # windows version, both win10 and win11 is 0x0A00
    add_compile_options(/bigobj)                                # error of not enough section
    add_compile_options(/permissive-)                           # Qt introduce this, but Qt was removed on windows
    add_compile_definitions(_USE_MATH_DEFINES)                  # M_PI
    
    # ──────────────────────────────────────────────────────────────
    # debug code for release config
    # uncomment the second line to force ON and overwrite cache
    # ──────────────────────────────────────────────────────────────
    option(MSVC_RELEASE_DEBUG "Turn off /O2, enable debug info" OFF) # declare cache entry, default OFF
    set(MSVC_RELEASE_DEBUG OFF CACHE BOOL "Turn off /O2, enable debug info" FORCE) # turn on
    if (MSVC_RELEASE_DEBUG)

        message(WARNING "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
        message(WARNING "XXXXXXXXXX enable debug for release XXXXXXXXXXXXXX")
        message(WARNING "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")

        string(REPLACE "/O2" "/Od" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
        string(REPLACE "/O2" "/Od" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
        add_compile_options(/Zi)
        add_link_options(/DEBUG)

        message("C++ Flags: ${CMAKE_CXX_FLAGS_RELEASE}")
        message("C Flags: ${CMAKE_C_FLAGS_RELEASE}")
    endif()
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")                 # position-independent code for unix
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")             # position-independent code for unix
endif()

################################# include cmake Utils and modle for FindXXX.cmake
# include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)    # utils
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")        # module


file(GLOB SRC "${CMAKE_SOURCE_DIR}/src/*.cpp")
add_library(${PROJECT_NAME} SHARED ${SRC})
target_compile_definitions(${PROJECT_NAME} PRIVATE BUILD_SHARED)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/include)

################################# install settings
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)# 通过 -DCMAKE_INSTALL_PREFIX=...（或 cmake --install --prefix ...）指定
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install CACHE PATH "..." FORCE)#install(TARGETS ... DESTINATION bin)中 DESTINATION 是相对于 CMAKE_INSTALL_PREFIX的
endif()#安装路径=CMAKE_INSTALL_PREFIX/DESTINATION，DESTINATION在CMakeLists中直接指定

#安装 target + 顺便把target加入导出集合
install(TARGETS ${PROJECT_NAME} #TARGETS表示安装通过add_library等构建的目标，而不是文件等
    EXPORT ${PROJECT_NAME}Targets
    LIBRARY DESTINATION lib/$<CONFIG>
    ARCHIVE DESTINATION lib/$<CONFIG>
    RUNTIME DESTINATION bin/$<CONFIG>
)

# Install headers
#FILES mcnp/helper.hpp：要安装（复制）的具体文件路径（相对当前 CMakeLists.txt 所在目录，或写成绝对路径也行）。
#DESTINATION include/：安装到的子目录（相对 CMAKE_INSTALL_PREFIX）。
install(FILES include/helper.hpp DESTINATION include/)

install(EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION lib/cmake/${PROJECT_NAME}
)

configure_file(${CMAKE_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in ${PROJECT_NAME}Config.cmake @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    DESTINATION lib/cmake/${PROJECT_NAME}
)