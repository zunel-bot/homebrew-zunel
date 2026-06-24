class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.23"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.23/zunel_darwin_arm64.zip"
      sha256 "830317d62cdf052fc0e89dafd8aca5507cbe703a9a97d5a0c05649c5dc9d3f86"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.23/zunel_darwin_amd64.zip"
      sha256 "0eaa0fddcbf6bb80c37fcad959ae7ea36f66531065793367c910ecc34e8f595c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.23/zunel_linux_arm64.tar.gz"
      sha256 "1bdf79e4062498c201ddfe9371ced6bfb405ed5997383b66ab23472b62fd1936"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.23/zunel_linux_amd64.tar.gz"
      sha256 "540993d070e338041437a04a9fe064abe22c3dceae9f1f706d5e88c0bc126b3e"
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
