cmake_minimum_required (VERSION 2.6)
project (LuaMD5)

# Lua
find_package (Lua REQUIRED)

# Our Module
add_library( md5 MODULE md5.c md5.def )
target_link_libraries ( md5 ${LUA_LIBRARIES} )
target_include_directories( md5 PRIVATE ${LUA_INCLUDE_DIR} )