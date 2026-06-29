class AccelerateLapack < Formula
  desc "CMake to create aliases for LAPACK for Apple Accelerate"
  homepage "https://github.com/lepus2589/accelerate-lapack"
  url "https://github.com/lepus2589/accelerate-lapack/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8f1b47cf2ed255b22d5204218ec27466d4187b383b50daa5aeb55de4f0360cc5"
  license "MIT"

  depends_on :macos

  on_macos do
    if MacOS.version < "13.3"
      odie "This formula requires macOS Ventura 13.3 or newer for LAPACK 3.9.1+ support."
    end
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
