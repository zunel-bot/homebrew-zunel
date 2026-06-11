class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.16"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.16/zunel_darwin_arm64.zip"
      sha256 "7517f3f5ee0a632216088b017f21c64c0b9e5d818482285d9c7f1c099df3e4ca"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.16/zunel_darwin_amd64.zip"
      sha256 "a750fe53614a61a71aa69852a0e35554eec7204f0a16ee2680c7f69118549c6d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.16/zunel_linux_arm64.tar.gz"
      sha256 "95639be271189584c57159dfd710631eda2c16fc01ac1c9b1438bb4b790d1f78"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.16/zunel_linux_amd64.tar.gz"
      sha256 "e3808919d173ef523b0d1b09503004c72e9bdc194e4a9bbb13c9c7e999967a86"
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
