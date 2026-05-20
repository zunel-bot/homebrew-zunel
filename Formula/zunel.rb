class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-tap"
  version "1.1.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.6/zunel_darwin_arm64.zip"
      sha256 "d9b8f1363dc0e74cfb609397a3f11191ed22fd55b1b051e9eb9cc1c05aa9b3d0"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.6/zunel_darwin_amd64.zip"
      sha256 "524fc860c5210815c1963a93c7c69c31845516b61afeec8cedf1221635e650d2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.6/zunel_linux_arm64.tar.gz"
      sha256 "e76bcd1c5054b1aa8f34f565b47b05e6e9d2e69ad9806b3213f917efd1a0cb87"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.6/zunel_linux_amd64.tar.gz"
      sha256 "fa0d70e885755ef48b353ec394d356fb1a9bc0efc02ff6c7ff3dd84a36241170"
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
