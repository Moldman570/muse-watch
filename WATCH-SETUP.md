# Setup and troubleshooting

## Start with the ready-made downloads

Download the APK or complete Windows bundle from [v0.3.0 Releases](https://github.com/Moldman570/muse-watch/releases/tag/v0.3.0). You do not need to rebuild the app or download its source. See README.md for Windows setup, and PHONE-START-HERE.md for phone installation.

## Manual ADB installation

Install Google's platform-tools from https://developer.android.com/tools/releases/platform-tools and download muse-watch-v0.3.0.apk. Put your computer and watch on the same trusted Wi-Fi and keep the watch unlocked.

Enable Developer options on the watch by tapping Software version repeatedly under Settings > About watch > Software information. Enable ADB debugging and Wireless debugging.

1. Open Pair new device on the watch. Run `adb pair WATCH_IP:PAIRING_PORT` on your computer and enter the six-digit code when prompted.
2. Return to the main Wireless debugging screen. Run `adb connect WATCH_IP:CONNECTION_PORT`. This port differs from the pairing port.
3. Run `adb devices` and identify your watch.
4. Run `adb -s WATCH_IP:CONNECTION_PORT install -r muse-watch-v0.3.0.apk`. The `-r` option preserves existing app data when the signing key matches.
5. Open Muse Watch on the watch and follow the account-pairing steps in README.md.

No SDK token belongs in these command arguments. Enter your own token on the watch or in the Windows helper's hidden prompt.

## Optional Python helper

If you already use Python and ADB, the repository includes scripts/setup-watch.py. Download that script and the APK, then run:

```sh
python3 setup-watch.py --serial WATCH_IP:CONNECTION_PORT --apk muse-watch-v0.3.0.apk --token
```

Use `py` instead of `python3` on Windows. Omit `--token` for a later update to preserve existing credentials. The helper transfers the token through stdin to app-private storage and checks its encrypted import; it never includes the token in command arguments.

## Account pairing

Wireless ADB pairing lets you install an app. Muse gadget pairing connects that app to your account. They are different steps.

Get your own token at https://gadgets.muse.ai/settings/sdk-tokens and review https://gadgets.muse.ai/sdk-terms. On the watch, choose Setup > Add SDK token, then Setup > Pair / reconnect. On your phone, open Muse > Settings > Devices, enable Developer mode, and add the matching MuseGadget. Select Current connection when prompted. Keep the watch app open.

## If connection fails

- Use the current watch IP and ports; they can change when wireless debugging or Wi-Fi restarts. Keep Pair new device open until pairing finishes.
- Check that both devices are on the same home network. Guest-network isolation or a VPN can prevent local ADB access.
- Turn wireless debugging off and back on, or restart the watch and installer if the connection is stale.
- A timeout while connecting to Muse is separate from ADB. Check watch internet access and account pairing.

The app disconnects when it leaves the foreground. Initial connection can take a few seconds. Wi-Fi works in the reported Watch5 Pro setup; phone-relayed internet and LTE remain untested.

## Using the app

Hold the green onscreen button, speak, and release to send. Grant microphone permission if prompted, then hold again. Slide upward to cancel. Recording is limited to 20 seconds. Keep the app open for the reply. If delivery is uncertain, check Muse on your phone before resending.

The Home/power assistant shortcut can open the app on compatible firmware; it does not implement hardware-button recording or release-to-send. The owner reports shortcut launch on a Watch5 Pro. Other firmware remains unverified.

## Updates and privacy

Use the same-signed release APK and `install -r` to preserve data. Uninstalling or clearing app data removes pairing and credentials. The published APK is debug-signed to support private token provisioning through `run-as`; the signing key is not published.

Turn off ADB debugging and Wireless debugging after installation. Do not post your SDK token, pairing code, credentials, or personal conversation in an issue or screenshot. No publisher token or account credentials are included.

See VERIFICATION.md for executed checks and separately identified user reports. License notices are in LICENSE, NOTICE.md, and licenses/.
