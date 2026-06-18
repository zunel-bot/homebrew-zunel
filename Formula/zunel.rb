class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.20"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.20/zunel_darwin_arm64.zip"
      sha256 "1076a0fa404f9c065f7d41f9717dce4043d57b157af0ebfd6c6746f0da50e3d7"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.20/zunel_darwin_amd64.zip"
      sha256 "bb61b034b27ecb167027a4261373b4f1980735ec748b7b286c735405376bc806"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.20/zunel_linux_arm64.tar.gz"
      sha256 "a2db1ea0ac15333315e87f8ba3fdc479c2525a55cae9d8f59b29e049c4d2c478"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.20/zunel_linux_amd64.tar.gz"
      sha256 "1cc77b970f3e39dd88f52ce8d7d6e3496ca657f726f36b66bf181241ccaeeb99"
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
