class AccelerateLapacke < Formula
  desc "CMake wrapper to build LAPACKE against Apple Accelerate"
  homepage "https://github.com"
  url "https://github.com/lepus2589/accelerate-lapack/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8f1b47cf2ed255b22d5204218ec27466d4187b383b50daa5aeb55de4f0360cc5"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "--preset", "accelerate-lapack32", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end


  test do
    assert_predicate lib/"liblapacke.dylib", :exist?
  end
end
