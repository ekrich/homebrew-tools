class AccelerateLapack < Formula
  desc "CMake to create aliases for LAPACK for Apple Accelerate"
  homepage "https://github.com/lepus2589/accelerate-lapack"
  url "https://github.com/lepus2589/accelerate-lapack/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8f1b47cf2ed255b22d5204218ec27466d4187b383b50daa5aeb55de4f0360cc5"
  license "MIT"

  bottle do
    root_url "https://github.com/ekrich/homebrew-tools/releases/download/accelerate-lapack-2.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "045917a8a787573f7fdd3738f0461783070c90a352144d69d46a3d2d1d7e0a5b"
  end

  depends_on "cmake" => :build
  depends_on :macos

  on_macos do
    odie "This formula requires macOS Ventura 13.3 or newer for LAPACK 3.9.1+ support." if MacOS.version < "13.3"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
