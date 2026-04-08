local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cmake", {
	s("cmake", {
		t({
			"cmake_minimum_required(VERSION 3.20)",
			"",
			"project(",
		}),
		i(1, "MyProject"),
		t({
			" VERSION 0.1.0 LANGUAGES CXX)",
			"",
			"set(CMAKE_EXPORT_COMPILE_COMMANDS ON)",
			"",
			"add_executable(${PROJECT_NAME}",
			"  src/main.cpp",
			")",
			"",
			"set_target_properties(${PROJECT_NAME} PROPERTIES",
			"  CXX_EXTENSIONS OFF",
			")",
			"",
			"target_include_directories(${PROJECT_NAME} PRIVATE",
			"  ${CMAKE_CURRENT_SOURCE_DIR}/src",
			")",
			"",
			"target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)",
			"",
			"if(MSVC)",
			"  target_compile_options(${PROJECT_NAME} PRIVATE",
			"    /W4",
			"    /WX",
			"  )",
			"else()",
			"  target_compile_options(${PROJECT_NAME} PRIVATE",
			"    -Wall",
			"    -Wextra",
			"    -Wpedantic",
			"    -Werror",
			"  )",
			"endif()",
			"",
		}),
		i(0),
	}),
})
