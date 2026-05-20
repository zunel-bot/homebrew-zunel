class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-tap"
  version "1.1.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.7/zunel_darwin_arm64.zip"
      sha256 "eb808844dbd23b7ffbefe084d0e45eb4a31aa23b5aa0c5b142d86e9a62761d0e"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.7/zunel_darwin_amd64.zip"
      sha256 "708394af7b953dcdc1f6194aaee54b8f5167e11e00375ea3bc4c9097081c4e55"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.7/zunel_linux_arm64.tar.gz"
      sha256 "60bc590504a17eb3a833639acef546410bd412e054e3292fe944b918bed5eadb"
    else
      url "https://github.com/zunel-bot/homebrew-tap/releases/download/v1.1.7/zunel_linux_amd64.tar.gz"
      sha256 "695a103d2e3b07e805ccd6fafc06f848a31a066296c5996d65dd7c2e703dd128"
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
