# Install from your Android phone

Galaxy Watch5 Pro, One UI Watch 8.0. Muse Watch v0.3 includes token entry on the watch, so computer provisioning is optional.

1. Download `muse-watch-v0.3.0.apk` onto your phone.
2. Use the watch APK installer you already use. Pair/connect it through your watch's Wireless debugging and select this APK. Install/update it **on the watch**, not as a phone app. For updates, preserve app data and use the provided same-signed APK.
3. Open **Muse Watch** from the watch app list. Tap **Setup > Add SDK token**.
4. On your phone, sign into https://gadgets.muse.ai/settings/sdk-tokens, review the SDK terms, and get a Gadget SDK token. Enter it in the watch's token field and tap **Save**. This requires entering the full token; phone-to-watch keyboard/paste support depends on your existing keyboard or installer. We have not confirmed that input method on your devices. Do not put the token in chat, shell command arguments, or screenshots.
5. Choose **Setup > Pair / reconnect** and grant Bluetooth permissions.
6. In the Muse phone app, go to **Settings > Devices**, enable **Developer mode**, add the matching **MuseGadget** displayed on the watch, and select **Current connection**. Keep the watch app open during pairing.
7. When Ready appears, hold the onscreen button. Grant microphone permission if prompted, then hold again. Speak and release to send. Slide upward to cancel. Keep the app open while waiting for the reply.

This separates **wireless-debugging pairing** (installing the APK) from **Muse gadget pairing** (connecting your Muse account). You need both for first setup.

The SDK token field is masked, does not prefill an existing token, disables saved view state/autofill, and blocks screenshots of the token dialog. Saving encrypts the token using Android Keystore. The entry is cleared when the dialog closes.

The app does not test or validate the token against Muse until you pair/connect. Saving locally is not proof that Muse accepted it.

After the first successful voice-message test, assign **Home double press > Muse Watch** in your watch's button settings. Long-press assistant replacement remains experimental; this version uses the onscreen record button.

Computer-based token entry remains available in WATCH-SETUP.md if entering a long token on the watch is inconvenient.
The owner reports live use on a Watch5 Pro. The phone installer/keyboard flow and other devices remain unverified.

Manual token entry is an optional sideloaded-prototype feature. Google recommends companion authentication instead of wearable password entry; a production Play Store version should use a phone companion. The token-entry method has a documented, narrowly scoped WearPasswordInput lint exception.
