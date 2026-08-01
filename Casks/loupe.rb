cask "loupe" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.0"
  sha256 arm:   "5135e2c36cb49c8caf9bc9671c04fcaed2e53ec9176ab23119ed3c60353b2398",
         intel: "28536e55deabd9aa0c06283f7971ada1cad36fb3ae1a344d036e4c835221e1b1"

  url "https://github.com/kryptonhq/loupe/releases/download/v#{version}/Loupe_#{version}_#{arch}.dmg",
      verified: "github.com/kryptonhq/loupe/"

  name "Loupe"
  desc "Open-source desktop client for Kubernetes"
  homepage "https://github.com/kryptonhq/loupe"

  # Matches `bundle.macOS.minimumSystemVersion` in tauri.conf.json, which
  # is Tauri v2's own floor. If the two drift, Homebrew installs a build
  # the Finder then refuses to open.
  depends_on macos: ">= :catalina"

  app "Loupe.app"

  # Said plainly rather than worked around. Loupe is ad-hoc signed but
  # not notarised, so Gatekeeper refuses it on first open. A cask can
  # strip the quarantine attribute in a postflight and make that
  # invisible — this one deliberately does not. Removing a security
  # attribute on someone's behalf, without them asking, is not a
  # decision an installer should make quietly.
  caveats <<~EOS
    Loupe is not yet notarised by Apple, so macOS will refuse to open it
    the first time. Either allow it once:

      System Settings -> Privacy & Security -> Open Anyway

    or install without the quarantine attribute:

      brew install --cask --no-quarantine #{token}

    Notarised builds are planned; see
    https://github.com/kryptonhq/loupe/blob/main/RELEASING.md
  EOS

  # Everything Loupe writes, so `brew uninstall --zap` leaves nothing.
  # `settings.json` lives in the Application Support directory; the
  # kubeconfig does not belong to us and is deliberately not listed.
  zap trash: [
    "~/Library/Application Support/ai.krypton.loupe",
    "~/Library/Caches/ai.krypton.loupe",
    "~/Library/HTTPStorages/ai.krypton.loupe",
    "~/Library/Preferences/ai.krypton.loupe.plist",
    "~/Library/Saved Application State/ai.krypton.loupe.savedState",
    "~/Library/WebKit/ai.krypton.loupe",
  ]
end
