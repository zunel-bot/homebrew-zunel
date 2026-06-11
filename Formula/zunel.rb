class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.17"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.17/zunel_darwin_arm64.zip"
      sha256 "c759a0d5a12ed3c91ea9cb3263b8fdd3df88b9d4445bd2bc413963eeff9f5ae2"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.17/zunel_darwin_amd64.zip"
      sha256 "2b8e2511f75c93425c3c43b7816ea819eea2df073cc803a44194304c1b17b99b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.17/zunel_linux_arm64.tar.gz"
      sha256 "1cb6acefb9b87df07505d7aa6ae070af3fe47803a5a65535cf4553a6a1f01427"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.17/zunel_linux_amd64.tar.gz"
      sha256 "85d55733c3fdd7564229eac60da616429fce2e90b269b6ef05370916369dc422"
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
