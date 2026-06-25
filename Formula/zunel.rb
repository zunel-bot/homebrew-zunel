class Zunel < Formula
  desc "Personal AI assistant: local chat REPL, Slack gateway, and built-in MCP servers"
  homepage "https://github.com/zunel-bot/homebrew-zunel"
  version "1.1.26"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.26/zunel_darwin_arm64.zip"
      sha256 "754ffe2184d947f44724e10e93b154c54f248653a5f1164efff0d738e9ae5351"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.26/zunel_darwin_amd64.zip"
      sha256 "ae1e197bd1e81c106d8295fac6326e661a6300e40c485da1cb698fb7a23d4482"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.26/zunel_linux_arm64.tar.gz"
      sha256 "9ab2103fa26f553b674a105e41d1c08b2acac5ea85ae45f882192697a419d4ef"
    else
      url "https://github.com/zunel-bot/homebrew-zunel/releases/download/v1.1.26/zunel_linux_amd64.tar.gz"
      sha256 "c8c47ce2786a2158cfae8ff2e0d5514e58dc10b66882c7b37c459fe32247fe3d"
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
