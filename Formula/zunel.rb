class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.18"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.18/zunel_darwin_arm64.zip"
      sha256 "8e8a08031f738b056302f16ba2a5ddd411b7e91deef787a29eb1baf61273a490"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.18/zunel_darwin_amd64.zip"
      sha256 "40c6f43ec3d109bcb51f4fc2ca6acfbf5c6417ff2b7fbb05d5b35c8bcbe994ef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.18/zunel_linux_arm64.tar.gz"
      sha256 "cebf2633ebf06171448b8b0eb99f6ac2a6b8bd4dc15c9da79972b9216e906909"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.18/zunel_linux_amd64.tar.gz"
      sha256 "6adf9c895501421e44e1c110afe31b62a200aee709cb73584524ded7f5602c18"
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
