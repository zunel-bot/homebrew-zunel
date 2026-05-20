class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-tap"
  version "1.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.3/zunel_darwin_arm64.zip"
      sha256 "595303c7952881379a694de15a948a6b295303a01d18131c5262e6c90e651a42"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.3/zunel_darwin_amd64.zip"
      sha256 "7cedf1f23c18bf0c158c66f54bae2ed6b2067fb73d408954c12a34e7fcedf75c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.3/zunel_linux_arm64.tar.gz"
      sha256 "f0dd7c85324d050d29cfce50836f8105ea27d4e0de03b490db044801673e4aae"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.3/zunel_linux_amd64.tar.gz"
      sha256 "2dce4f014796d87044ba3ad7753fbc33f82c82a7c8ff9bc18483e07efb6ad1c8"
    end
  end

  def install
    bin.install "zunel"
  end

  service do
    run [opt_bin/"zunel", "gateway"]
    keep_alive true
    log_path var/"log/zunel-gateway.out.log"
    error_log_path var/"log/zunel-gateway.err.log"
    environment_variables RUST_LOG: "info,zunel=info",
                          PATH: "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  def caveats
    <<~CAVEATS
      To run zunel's Slack gateway in the background and restart it at login:
        brew services start zunel

      To stop it:
        brew services stop zunel

      On macOS, screen capture and other TCC-gated features are more reliable
      when zunel is launched from a GUI terminal app that already has the
      relevant permissions granted.
    CAVEATS
  end

  test do
    system "#{bin}/zunel", "--version"
  end
end
