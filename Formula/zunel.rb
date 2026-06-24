class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.21"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.21/zunel_darwin_arm64.zip"
      sha256 "6752848c1142ae04146272f7ff5c78304bb06cabec9cb1a5aec97cb786509f3d"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.21/zunel_darwin_amd64.zip"
      sha256 "06225bd43442cccffb7e0904155176a2beaf7b54126e87a6414c26c8ae3a7476"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.21/zunel_linux_arm64.tar.gz"
      sha256 "9cb4309d9fb32d95b4b127a04aec8efee0b779a1978de99934483a10b2d04a52"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.21/zunel_linux_amd64.tar.gz"
      sha256 "eb262941bfca7a5929f0b31a64c954aaf3dae9fe322dea09e584082441138cce"
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
