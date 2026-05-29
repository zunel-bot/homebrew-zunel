class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.9/zunel_darwin_arm64.zip"
      sha256 "6313a2e526eeaa4698af24df1de436c09f7898a5c11dbf66d2ec38cc2ab03889"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.9/zunel_darwin_amd64.zip"
      sha256 "fcd5285b6971ad16ad8d52a149cd90c9cb66415849cd7b30e0a5336c0cb27e9f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.9/zunel_linux_arm64.tar.gz"
      sha256 "81d962ef066cdb99965f7ebb5b159022a8ce98f9691668ddc6e48ded32310612"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.9/zunel_linux_amd64.tar.gz"
      sha256 "9024902c5bd3ab1ec6ff349d2b8374182390cc47ca34104a0dc08f703ab1c3b3"
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
