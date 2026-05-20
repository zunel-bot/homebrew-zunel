class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-tap"
  version "1.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.5/zunel_darwin_arm64.zip"
      sha256 "84130e8df8a712904629edf24efd9ac7f9995efe8cb27d8a713608b2e7131293"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.5/zunel_darwin_amd64.zip"
      sha256 "f16bb629d5b4d6b65d68f9c135603ed210efaa5bcf0f91a2fa7fa1ecd52699e5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.5/zunel_linux_arm64.tar.gz"
      sha256 "ab9f89dc236f5f250dfcda965745c0b475878467b25a8e20875283dab929600e"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.5/zunel_linux_amd64.tar.gz"
      sha256 "c187794f121e1e35efdf3ada4af62cf5e9ea2fc9eeff0c929cf2f9ac1febc36d"
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
