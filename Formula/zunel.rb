class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.27"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.27/zunel_darwin_arm64.zip"
      sha256 "ea71cd27f8c0deb724cab5fd4ad8c3717c97633867f15ac271e068019787cb25"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.27/zunel_darwin_amd64.zip"
      sha256 "7d131d7c15ff84269128c1cf03bcaff1f1b6ac42c178ce891aebcc48eaae45a9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.27/zunel_linux_arm64.tar.gz"
      sha256 "c5e8339eb0a20b8f0ee12277475279afeeda8eda8f2dbcb9d018dacf60ed906d"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.27/zunel_linux_amd64.tar.gz"
      sha256 "2ebfa4450018a8af3cc11222eeba9e7fd27dbd969cfba47dbdba34794b81c14b"
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
