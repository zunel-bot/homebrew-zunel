class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.25"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.25/zunel_darwin_arm64.zip"
      sha256 "cb6bbc1a99a1d7d66e4da27e396a704304a4d79c6270886ec7ca0094eb537473"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.25/zunel_darwin_amd64.zip"
      sha256 "2abcaf10f7fdf7229050a2e1d554d0cdcbcde1435fa27442356107d7f0435c40"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.25/zunel_linux_arm64.tar.gz"
      sha256 "cbde8702c60e3a1f2f7988e7f48195de0ff7d455a2084b5d0a68089318e784f9"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.25/zunel_linux_amd64.tar.gz"
      sha256 "576596f361a658c994b7935146f106a42648ca7c412828390cbe7aebba389846"
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
