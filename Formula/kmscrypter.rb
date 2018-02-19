class Kmscrypter < Formula
  desc "AWS assume role credential wrapper"
  homepage "https://github.com/masahide/kmscrypter"
  url "https://github.com/masahide/kmscrypter/releases/download/v0.1.0/kmscrypter_Darwin_x86_64.tar.gz"
  version "0.1.0"
  sha256 "547fc38943ce0094d2091ecf79a580782b9cdcfc0ae25a714eefcce880e1561b"

  def install
    bin.install "kmscrypter"
  end

  test do
    system "#{bin}/kmscrypter -v"
  end
end
