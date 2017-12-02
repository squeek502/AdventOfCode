cmake_minimum_required (VERSION 2.6)
project (LuaBitOp)

# Lua
find_package (Lua REQUIRED)

# Our Module
add_library( bit MODULE bit.c bit.def )
target_link_libraries ( bit ${LUA_LIBRARIES} )
target_include_directories( bit PRIVATE ${LUA_INCLUDE_DIR} )