# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "OpenrestyBuilder"
version = v"1.15.8"

# Collection of sources required to build OpenrestyBuilder
sources = [
    "https://openresty.org/download/openresty-1.15.8.2.tar.gz" =>
    "436b4e84d547a97a18cf7a2522daf819da8087b188468946b5a89c0dd1ca5d16",

    "https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz" =>
    "0b8e7465dc5e98c757cc3650a20a7843ee4c3edf50aaf60bb33fd879690d2c73",

    "https://www.openssl.org/source/openssl-1.0.2t.tar.gz" =>
    "14cb464efe7ac6b54799b34456bd69558a749a4931ecfd9cf9f71d7881cac7bc",

    "https://www.zlib.net/zlib-1.2.11.tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd openresty-1.15.8.2/
./configure --prefix=$prefix --with-cc=$CC --with-zlib=$WORKSPACE/srcdir/zlib-1.2.11 --with-openssl=$WORKSPACE/srcdir/openssl-1.0.2t --with-pcre=$WORKSPACE/srcdir/pcre-8.43 --with-pcre-jit
make install
rm $prefix/bin/openresty 
cd $prefix/bin/
ln -fs ../nginx/sbin/nginx ./openresty
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:musl),
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "openresty", :openresty)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

