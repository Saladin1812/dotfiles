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
			"set(CMAKE_CXX_EXTENSIONS OFF)",
			"",
			"add_executable(${PROJECT_NAME}",
			"  src/main.cpp",
			")",
			"",
			"target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)",
			"",
			"target_compile_options(${PROJECT_NAME} PRIVATE",
			"  -Wall",
			"  -Wextra",
			"  -Wpedantic",
			"  -Werror",
			")",
			"",
		}),
		i(0),
	}),
})
