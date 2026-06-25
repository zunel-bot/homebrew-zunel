class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.24"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.24/zunel_darwin_arm64.zip"
      sha256 "5ba5fee002cef030768d3ee95e581f508932f92d0e0b640a29e06414ca35b3a3"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.24/zunel_darwin_amd64.zip"
      sha256 "1062471025efd2207f28ea4e4d3ca84848dd1070c655c2fb2cc549d990784adb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.24/zunel_linux_arm64.tar.gz"
      sha256 "ed9173995fe0bddabc336219e4f3564e41b036da2c5de8335b7fc00aedf35ae1"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.24/zunel_linux_amd64.tar.gz"
      sha256 "9a49db41d9df9ed652659812b013dd4b589ae709b25dc6e2964df7e522eb0be3"
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
