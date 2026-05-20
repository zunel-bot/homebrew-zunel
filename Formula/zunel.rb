class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/zunel"
  version "1.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.2/zunel_darwin_arm64.zip"
      sha256 "cef5210026a4d21378d2ab85243ab0023b9f15a8daba3462bf9e2578998f6f20"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.2/zunel_darwin_amd64.zip"
      sha256 "274cc866def81baf176574d9d6070d457b67ee7d2e56765f12eed827c8741dc2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.2/zunel_linux_arm64.tar.gz"
      sha256 "2b0c367cd3e827c7da8085284bb50e0cd4b32577540dd3c4f1b5838daea0e3e3"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.2/zunel_linux_amd64.tar.gz"
      sha256 "cb066756aefea627aceca98c86129e2a7f0360fb5701154aa3673229f6d7de0e"
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
