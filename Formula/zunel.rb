class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-tap"
  version "1.1.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.4/zunel_darwin_arm64.zip"
      sha256 "34c41a8823d5b2b3be79bf7d0c7cd8eb8687e4bee770d58c23eecf3f3e3f0ffb"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.4/zunel_darwin_amd64.zip"
      sha256 "a4d0fef8b8e05692960afaf0936767b6fe24162efd958f15782cb10efc1c6a5a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.4/zunel_linux_arm64.tar.gz"
      sha256 "6fa6daa9152bf93ad36a30dc1af690acb2837c9a7bbcf0ab494db1bd93adfc22"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.4/zunel_linux_amd64.tar.gz"
      sha256 "fb5ce69653b70ee9179f50157379f4fd2557ade6dd2cc9c7fb95562fa12b2a2d"
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
