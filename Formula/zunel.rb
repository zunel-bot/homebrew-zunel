class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.19"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.19/zunel_darwin_arm64.zip"
      sha256 "676a6e76401ae4438508e398aa83180973d044ef0fb22a1c1a22c48d12a9935e"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.19/zunel_darwin_amd64.zip"
      sha256 "ae68450d1cd6953e86c8e63b9324732749d261153b744e60f4bfd21b81973381"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.19/zunel_linux_arm64.tar.gz"
      sha256 "781d401ace5a58c50cfd3994b4426490e07365b76618419f2ac10337cf20dfda"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.19/zunel_linux_amd64.tar.gz"
      sha256 "cd89801eca12f07638b9c582495604e632c0fcf941d16b83128858a154683319"
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
