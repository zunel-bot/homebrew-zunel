class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.8/zunel_darwin_arm64.zip"
      sha256 "99c2c05fc1938115f3cf658e2c18ba3ad5165b02260b86bb984140238cfb93ba"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.8/zunel_darwin_amd64.zip"
      sha256 "7c69d6c7f8d716eb3e21c4f11024138edf2ed05b8cdc7e4f5dd6e86971ae5b59"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.8/zunel_linux_arm64.tar.gz"
      sha256 "70f1c4344ed480c785339aa18eee9c22b96a37d265809ca029493981e895e9fd"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.8/zunel_linux_amd64.tar.gz"
      sha256 "f19cf083b10d8084c945d8d57ed4001d004753ef3d05a6e4f868c8879d56926a"
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
