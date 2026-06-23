class AccelerateLapacke < Formula
  desc "CMake wrapper to build LAPACKE against Apple Accelerate"
  homepage "https://github.com/lepus2589/accelerate-lapacke"
  url "https://github.com/lepus2589/accelerate-lapacke/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "532ab84fda3f0fb17abbe2a1752aedfe4299d95ebd5610f30608f993841236b7"
  license "MIT"

  # Tells Homebrew to pass un-sandboxed system environment paths
  env :std
  # Alternative explicit hash syntax
  sdk_path = DevelopmentTools.locate("sdk")
  ENV["CFLAGS"] = "#{ENV["CFLAGS"]} -isysroot #{sdk_path}"
  ENV["LDFLAGS"] = "#{ENV["LDFLAGS"]} -isysroot #{sdk_path}"


  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "ekrich/tools/accelerate-lapack"

  # Restored the full, valid download link layout for Netlib
  resource "reference-lapack" do
    url "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz"
    sha256 "eac9570f8e0ad6f30ce4b963f4f033f0f643e7c3912fc9ee6cd99120675ad48b"
  end

  def install
    # Force CMake to isolate build tests using Apple's System C Compiler and Homebrew's Fortran compiler
    ENV["CC"] = "/usr/bin/cc"
    ENV["FC"] = "#{Formula["gcc"].opt_bin}/gfortran"

    dep_source = Formula["ekrich/tools/accelerate-lapack"].opt_prefix.to_s
    lapack_src = (buildpath/"build/_deps/reference-lapack-src").to_s

    # Unpack the valid resource files directly into our local folder path
    resource("reference-lapack").stage(lapack_src)

    # Completely isolate CMake by defining standard flags manually.
    # This leaves out the hidden TOP_LEVEL_INCLUDES script that blocks compilation.
    manual_cmake_args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_LIBDIR=#{lib}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_ACCELERATELAPACK=#{dep_source}
      -DFETCHCONTENT_SOURCE_DIR_reference_lapack=#{lapack_src}
      -DFETCHCONTENT_SOURCE_DIR_REFERENCE_LAPACK=#{lapack_src}
      -DAccelerateLAPACK_DIR=#{dep_source}/share/cmake/AccelerateLAPACK"
    ]

    system "cmake", "-S", ".", "-B", "build", "--preset", "accelerate-lapacke32", *manual_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_predicate lib/"liblapacke.dylib", :exist?
  end
end
