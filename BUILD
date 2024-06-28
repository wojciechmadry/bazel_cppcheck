filegroup(
    name = "cppcheck_executable_default",
    srcs = [],  # empty list: system cppcheck
)

label_flag(
    name = "cppcheck_executable",
    build_setting_default = ":cppcheck_executable_default",
    visibility = ["//visibility:public"],
)

filegroup(
    name = "cppcheck_flags_default",
    srcs = ["cppcheck_flags.txt"],
)

label_flag(
    name = "cppcheck_flags",
    build_setting_default = ":cppcheck_flags_default",
    visibility = ["//visibility:public"],
)

