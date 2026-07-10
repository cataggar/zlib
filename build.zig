const std = @import("std");

// zlib 1.3.2, built from the real upstream sources (github.com/madler/zlib,
// tag v1.3.2) with zig cc. zlib needs no generated headers: the checked-in
// zconf.h is already self-contained, using plain preprocessor feature
// detection (`#ifdef STDC`, `#if HAVE_UNISTD_H-0`, etc.) instead of values
// substituted by `./configure` -- so unlike pixman/glib/libiconv/gettext/
// nettle, this build.zig needs no WriteFile-generated config headers at all.
const sources = [_][]const u8{
    "adler32.c",
    "compress.c",
    "crc32.c",
    "deflate.c",
    "gzclose.c",
    "gzlib.c",
    "gzread.c",
    "gzwrite.c",
    "infback.c",
    "inffast.c",
    "inflate.c",
    "inftrees.c",
    "trees.c",
    "uncompr.c",
    "zutil.c",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod.addIncludePath(b.path("."));
    mod.addCSourceFiles(.{
        .files = &sources,
        .flags = &.{"-std=c89"},
    });

    const lib = b.addLibrary(.{
        .name = "z",
        .linkage = .static,
        .root_module = mod,
    });
    lib.installHeader(b.path("zlib.h"), "zlib.h");
    lib.installHeader(b.path("zconf.h"), "zconf.h");

    b.installArtifact(lib);
}
