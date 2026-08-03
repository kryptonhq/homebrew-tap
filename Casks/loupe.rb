cask "loupe" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.1"
  sha256 arm:   "357f2c36e33dafc2bf2adc5a717f6dc8792d7f8fdb39d0dfbd93434d01ec652a",
         intel: "98c5c14b32629c4f80061f3bd9996872b0e7bc7fa265579b1c48ef4415d4f0ba"

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
