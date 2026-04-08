local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.add_snippets("cmake", {
  s("cmake", {
    t {
      "cmake_minimum_required(VERSION 3.20)",
      "",
      "project(",
    },
    i(1, "MyProject"),
    t {
      " VERSION 0.1.0 LANGUAGES CXX)",
      "",
      "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)",
      "set(CMAKE_CXX_STANDARD 20)",
      "set(CMAKE_CXX_STANDARD_REQUIRED ON)",
      "set(CMAKE_CXX_EXTENSIONS OFF)",
      "",
      "add_compile_options(",
      "  -Wall",
      "  -Wextra",
      "  -Wpedantic",
      "  -Werror",
      ")",
      "",
      "file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS",
      '  "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"',
      ")",
      "",
      "add_executable(",
    },
    i(2, "my-project"),
    t {
      "  ${SOURCE_FILES}",
      ")",
      "",
      "target_include_directories(",
    },
    rep(2),
    t {
      " PRIVATE",
      "  ${CMAKE_CURRENT_SOURCE_DIR}/src",
      ")",
      "",
    },
    i(0),
  }),
})
