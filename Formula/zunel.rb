class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.28"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.28/zunel_darwin_arm64.zip"
      sha256 "5a6be9bc159ca933673bf494b43d13d7e69ee833ee41941d0486b4208ede794f"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.28/zunel_darwin_amd64.zip"
      sha256 "45422cb5e97716f1bbe392aaeab529d25d7972ee07997d142debdea313e42b1b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.28/zunel_linux_arm64.tar.gz"
      sha256 "7aacf8fd66baf1e7871799cffe05f80c76cce8542b1bae8b20712dddb2c18b4e"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.28/zunel_linux_amd64.tar.gz"
      sha256 "9af99659da8f7f4a0bb1928d06eb8dfb41640f0e929ed3d9348cdd83e87ab575"
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
