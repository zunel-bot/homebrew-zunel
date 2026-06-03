class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.13/zunel_darwin_arm64.zip"
      sha256 "dbf3e4498825269459495d08cdcad83bad5e0a2f762b0e747fb5adceda4e8f1d"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.13/zunel_darwin_amd64.zip"
      sha256 "abb8ca52e88c0f2a86cfcda423f4c287897d4653d49d3bc615aa79940ca1d7d1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.13/zunel_linux_arm64.tar.gz"
      sha256 "f09b4e579ba698df17a05d443a115fcc7f63b782eaf5c777c7bed8d47fb370d6"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.13/zunel_linux_amd64.tar.gz"
      sha256 "c74a309ddf5215147aee3fa6fb3ae93de924c937f3a5657b1df23b6d54ff7848"
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
