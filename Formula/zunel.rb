class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.11"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.11/zunel_darwin_arm64.zip"
      sha256 "5fc8abf7c8a2ff9fd3b371809fd154f71218f76b2aaea4938f37be4967700460"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.11/zunel_darwin_amd64.zip"
      sha256 "a47629a433fa0956649a873650bae684cbd22b55c71f9a3f5e2c88373ddca813"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.11/zunel_linux_arm64.tar.gz"
      sha256 "436ccea23d3db8b24ebbd11d43ae138e519e01e1b4e513102148359facb2696c"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.11/zunel_linux_amd64.tar.gz"
      sha256 "717a582de6ae95f75d2917899ed8f6dc7109243aa16320a0b375334cd09f64d3"
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
