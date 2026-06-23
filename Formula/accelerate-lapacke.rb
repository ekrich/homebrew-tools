class AccelerateLapacke < Formula
  desc "CMake wrapper to build LAPACKE against Apple Accelerate"
  homepage "https://github.com/lepus2589/accelerate-lapacke"
  url "https://github.com/lepus2589/accelerate-lapacke/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "532ab84fda3f0fb17abbe2a1752aedfe4299d95ebd5610f30608f993841236b7"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "ekrich/tools/accelerate-lapack" # Native dependency tracking

  # The official Netlib source archive required by the compilation script
  resource "reference-lapack" do
    url "https://github.com"
    sha256 "2f59e7c1c122e9121e6fca95e3fa76e025ddc444f35a8dedf3f50d1794e36c05"
  end

  def install
    # Point to the build directory where the first formula dropped the source mapping files
    dep_source = Formula["ekrich/tools/accelerate-lapack"].opt_prefix

    #Extract the Netlib source package into your local build path
    resource("reference-lapack").stage(buildpath/"build/_deps/reference-lapack-src")


    # Add structural variables to completely override and short-circuit FetchContent
    args = std_cmake_args + [
      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
      "-DFETCHCONTENT_SOURCE_DIR_ACCELERATELAPACK=#{dep_source}",
      "-DFETCHCONTENT_SOURCE_DIR_REFERENCE_LAPACK=#{buildpath}/build/_deps/reference-lapack-src",
      "-DAccelerateLAPACK_DIR=#{dep_source}/share/cmake/AccelerateLAPACK"
    ]

    # Configure, compile, and install using standard Homebrew parameters
    system "cmake", "-S", ".", "-B", "build", "--preset", "accelerate-lapacke32", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_predicate lib/"liblapacke.dylib", :exist?
  end
end
