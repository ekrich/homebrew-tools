class AccelerateLapacke < Formula
  desc "CMake wrapper to build LAPACKE against Apple Accelerate"
  homepage "https://github.com/lepus2589/accelerate-lapacke"
  url "https://github.com/lepus2589/accelerate-lapacke/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "532ab84fda3f0fb17abbe2a1752aedfe4299d95ebd5610f30608f993841236b7"
  license "MIT"

  # Keep standard environment as requested
  env :std

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "ekrich/tools/accelerate-lapack"

  resource "reference-lapack" do
    url "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz"
    sha256 "eac9570f8e0ad6f30ce4b963f4f033f0f643e7c3912fc9ee6cd99120675ad48b"
  end

  def install
    # Force compilers recommended by documentation
    ENV["CC"] = "/usr/bin/cc"
    ENV["FC"] = "#{formula_opt_bin("gcc")}/gfortran"

    # Define resource mapping directory
    dep_source = formula_opt_prefix("ekrich/tools/accelerate-lapack").to_s
    lapack_src = (buildpath/"build/_deps/reference-lapack-src").to_s

    # Force create the directory stack so the unzipper satisfies local path checks
    mkdir_p lapack_src
    resource("reference-lapack").stage(lapack_src)

    # Uses a flexible regex layout that handles single/double quotes, spaces,
    # and multiline variations cleanly across different versions of the source code.
    inreplace "src/CMakeLists.txt" do |s|
      s.gsub!(/FetchContent_Declare\s*\(\s*["']?reference-lapack["']?.*?\)/m, "")
      s.gsub!(/FetchContent_MakeAvailable\s*\(\s*["']?reference-lapack["']?\s*\)/,
              "add_subdirectory(#{lapack_src} ${CMAKE_CURRENT_BINARY_DIR}/reference-lapack-build)")
    end

    # Dynamically find the config directory regardless of the version suffix
    Dir.glob("#{dep_source}/share/cmake/AccelerateLAPACK*").first

    manual_cmake_args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_LIBDIR=#{lib}
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
      -DAccelerateLAPACK_DIR=#{dep_source}/share/cmake/AccelerateLAPACK
    ]

    system "cmake", "-S", ".", "-B", "build", "--preset", "accelerate-lapacke32", *manual_cmake_args
    system "cmake", "--build", "build"
    # Force CMake to install into Homebrew's target folder, bypassing the preset's default location
    system "cmake", "--install", "build", "--prefix", prefix.to_s
  end

  test do
    assert_path_exists lib/"liblapacke.dylib"
  end
end
