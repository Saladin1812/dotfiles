local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cmake", {
	s("cmake", {
		t({
			"cmake_minimum_required(VERSION 3.5.0)",
			"",
			"set(CMAKE_EXPORT_COMPILE_COMMANDS ON)",
			"",
			'set(VERSION "0.0.1")',
			"get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)",
			"",
			"project(${PROJECT_NAME} VERSION ${VERSION} LANGUAGES CXX)",
			"",
			'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -std=c++20")',
			'set(source_dir "${PROJECT_SOURCE_DIR}/src/")',
			"",
			"file(GLOB source_files",
			'	"${source_dir}/*.cpp"',
			'	"${source_dir}/*.h"',
			'	"${source_dir}/*.hpp"',
			")",
			"",
			"add_executable(${PROJECT_NAME} ${source_files})",
			"",
		}),
		i(0),
	}),
})
