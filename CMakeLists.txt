cmake_minimum_required(VERSION 3.30)
project(lua-pong)

# find packages
find_package(SDL2 REQUIRED)
find_package(OpenGL REQUIRED)

find_package(Lua 5.4 REQUIRED)
if(LUA_FOUND)
    add_library(Lua::Lua INTERFACE IMPORTED)
    set_target_properties(Lua::Lua PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${LUA_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "${LUA_LIBRARIES}"
    )
endif()

# exec
add_executable(lua-engine engine.c)

target_link_libraries(lua-engine PUBLIC 
    SDL2
    OpenGL
    Lua::Lua
)

# add test
add_executable(test-engine test.c)

target_link_libraries(test-engine PUBLIC 
    SDL2
    OpenGL
    Lua::Lua
)
