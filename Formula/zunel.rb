class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.10"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.10/zunel_darwin_arm64.zip"
      sha256 "71feca70533d0495ed319d43940220f3919733ed0f6a305d1aaff18f319e14ee"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.10/zunel_darwin_amd64.zip"
      sha256 "5b481d07d14a62c6f6138df2947c7d7364cd48028e397de23ef83c2ebacb1ee9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.10/zunel_linux_arm64.tar.gz"
      sha256 "5049950188415fe3c18e58561584d72bde8aaadf6c4589a9d60d072253b170f3"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.10/zunel_linux_amd64.tar.gz"
      sha256 "9d8d4085b5717325075cdecc201d69a791a870c50b100f6f2a9c7a5369e5b34b"
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
