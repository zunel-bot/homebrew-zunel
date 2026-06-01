class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.12"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.12/zunel_darwin_arm64.zip"
      sha256 "2747a8710919977a8c4832dadd087a0b3bb92453315fa6993529b46a0e99c318"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.12/zunel_darwin_amd64.zip"
      sha256 "42830b873591ca731c50291d22d820d88eee3d1555c3dcfc78437de8cdbfc9f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.12/zunel_linux_arm64.tar.gz"
      sha256 "7a079830461048971619043f62b080f2d38be4566df54668a59a9de6270a65d4"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.12/zunel_linux_amd64.tar.gz"
      sha256 "308bcdbe4520337b5484b86f9e2677f43ff1abe78f0b94ccfec381f7845d8a1a"
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
