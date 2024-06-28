load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _rule_sources(ctx, attr):
    srcs = []
    if hasattr(attr, "srcs"):
        for src in attr.srcs:
            srcs += [src for src in src.files.to_list() if src.is_source]
    if hasattr(attr, "hdrs"):
        for hdr in attr.hdrs:
            srcs += [hdr for hdr in hdr.files.to_list() if hdr.is_source]
    return srcs

def _cppcheck_rule_impl(ctx):
    wrapper = ctx.attr.cppcheck_wrapper.files.to_list()[0]
    exe = ctx.attr.cppcheck_executable

    # Declare symlinks
    cppcheck = ctx.actions.declare_file("run_cppcheck.sh")

    args = []
    srcs = _rule_sources(ctx, ctx.attr)

    # this is consumed by the wrapper script
    if len(exe.files.to_list()) == 0:
        args.append("cppcheck")
    else:
        args.append(exe.files_to_run.executable.basename)

    # Configure cppcheck script
    ctx.actions.symlink(output = cppcheck, target_file = wrapper)

    # Add cppcheck flags
    flags_file = ctx.attr.cppcheck_flags.files.to_list()[0]
    args.append(flags_file.short_path)

    # Add files to analyze
    for src in srcs:
        args.append(src.short_path)


    ctx.actions.write(
        output = ctx.outputs.executable,
        content = "./{binary} {args}".format(
            binary = cppcheck.short_path,
            args = " ".join(args),
        ),
        is_executable = True,
    )
    # Setup runfiles
    runfiles = ctx.runfiles(files = srcs + [cppcheck, flags_file])
    runfiles_basefolder = runfiles.files.to_list()[0].dirname
    return DefaultInfo(runfiles = runfiles)

cppcheck_test = rule(
    implementation = _cppcheck_rule_impl,
    test = True,
    fragments = ["cpp"],
    attrs = {
        'deps' : attr.label_list(),
        "cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "cppcheck_wrapper": attr.label(default = Label("//cppcheck:cppcheck")),
        "cppcheck_executable": attr.label(default = Label("//:cppcheck_executable")),
        "cppcheck_flags": attr.label(default = Label("//:cppcheck_flags"), allow_files = True),
        'srcs' : attr.label_list(allow_files = True),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
