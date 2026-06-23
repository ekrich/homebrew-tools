class AccelerateLapacke < Formula
  desc "CMake wrapper to build LAPACKE against Apple Accelerate"
  homepage "https://github.com"
  url "https://github.com/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "--preset", "accelerate-lapacke32", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end


  test do
    assert_predicate lib/"liblapacke.dylib", :exist?
  end
end
