class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.22"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.22/zunel_darwin_arm64.zip"
      sha256 "75dce09b375125b116ae62de453528d3a5a6e5370d0b1a4c46ec8a700ddbd172"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.22/zunel_darwin_amd64.zip"
      sha256 "ede5595325ce7104824f1e5c9d1a1353360e937ed92a55e6cffc388af33ba034"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.22/zunel_linux_arm64.tar.gz"
      sha256 "bd1d85280d2b2bed6993f263fe3ed8c6c68ffd1596c53b8bc2c533a4f60ec330"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.22/zunel_linux_amd64.tar.gz"
      sha256 "801d361129f142ca0d59d690dfe6b2a7a1dbc08b04536708e18582b6b1f1a713"
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
