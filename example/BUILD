load("//cppcheck:cppcheck.bzl", "cppcheck_test")

cppcheck_test(
    name = 'good_cpp',
    srcs = [
        "good.cpp"
    ],
)

cppcheck_test(
    name = 'bad_cpp',
    srcs = [
        "bad.cpp"
    ],
)

cppcheck_test(
    name = 'bad_hpp',
    srcs = [
        "bad_hdr.hpp"
    ],
    cppcheck_flags = "custom_flags.txt",
)
