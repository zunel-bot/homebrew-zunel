class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.14"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.14/zunel_darwin_arm64.zip"
      sha256 "d8413cb25065cdb10f8f4077e52b01590d55303fa6f6a92e3aff6dc1736454ab"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.14/zunel_darwin_amd64.zip"
      sha256 "7d3b46b0fba85136fb20a348feb26549958b9c1b38143915c62703505cdd369c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.14/zunel_linux_arm64.tar.gz"
      sha256 "938fc7ca2b42940ff30ce61884cbc3f3370437c3acaf853773b9e9b5aaf955e8"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.14/zunel_linux_amd64.tar.gz"
      sha256 "fe8fb8c5744dea2ed99a8efb84b6e81871b4a43f26910d1698863db5f3e83fc8"
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
