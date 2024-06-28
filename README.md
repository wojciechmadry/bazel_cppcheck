# Bazel cppcheck

Run [cppcheck](https://cppcheck.sourceforge.io/) with [bazel](https://bazel.build/)/[dazel](https://github.com/nadirizr/dazel).


## Usage

1. Add repo to your bazel `WORKSPACE`
```sh
git_repository(
  name = "bazel_cppcheck",
  commit = "326aec7a12d803fb744c76c09e4f83c8947e0af4",
  remote = "https://github.com/wojciechmadry/bazel_cppcheck.git",
)
```

2. [Optional] Change default cppcheck flags file
```sh
filegroup(
       name = "cppcheck_flags",
       srcs = [".cppcheck"],
       visibility = ["//visibility:public"],
)
```

3. Test your files
```sh
load("@bazel_cppcheck//cppcheck:cppcheck.bzl", "cppcheck_test")

cppcheck_test(
  name = "cppcheck_skip_list_test",
  srcs = [
    "file.hpp",
    "file1.cpp",
  ],
  visibility = ["//visibility:public"],
  cppcheck_flags = "//:cppcheck_flags"
)
```

4. [Optional] Change other avaliable rule settings

```sh
'deps' : attr.label_list(),
"cppcheck_wrapper": attr.label(default = Label("//cppcheck:cppcheck")),
"cppcheck_executable": attr.label(default = Label("//:cppcheck_executable")),
"cppcheck_flags": attr.label(default = Label("//:cppcheck_flags"), allow_files = True),
'srcs' : attr.label_list(allow_files = True),
```
## What is `cppcheck_flags`

Cppcheck program can be configure with many options. (`cppcheck --help`)

To provide options to the bazel rule they should be stored in configuration file (`cppcheck_flags`) on a single line.

For example:

```
--enable=warning --error-exitcode=1
```

or
```
--enable=warning --xml
```

## Examples


### bad_cpp

Run cppcheck on file with violations.

It use `cppcheck_flags.txt` cppcheck flags by default.

Return code is error code
```sh
dazel test //example:bad_cpp
```


### bad_hpp

Run cppcheck on file with violations.

It use `custom_flags.txt` cppcheck flags.

Return code shall be `0` (Because custom flags are set)

```sh
dazel test //example:bad_hpp
```

### good_cpp

Run cppcheck on file without violations.

It use `cppcheck_flags.txt` cppcheck flags by default.

Return code shall be `0`.
```sh
dazel test //example:good_cpp
```
