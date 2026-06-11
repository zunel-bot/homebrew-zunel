class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.15"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.15/zunel_darwin_arm64.zip"
      sha256 "c88998666dc02c9662e6495f5ecfe38126c4f586e8e223d7ea9a0115d63e86de"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.15/zunel_darwin_amd64.zip"
      sha256 "ed6e6569d590b358304b83c13ed95f7aa62f494a80608fcabe1980bc0e890931"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.15/zunel_linux_arm64.tar.gz"
      sha256 "a0b2064199ccaa2708d72b079f251ab70bb258676bafd65a658021aa017d0754"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.15/zunel_linux_amd64.tar.gz"
      sha256 "ee67a0d9ed67d32fad34bfca9c05cf23f3b866aa99a7ab1cb1178359d00103d2"
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
