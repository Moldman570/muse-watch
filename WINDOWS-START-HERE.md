# Windows installation

Download muse-watch-windows-v0.3.0.zip from [GitHub Releases](https://github.com/Moldman570/muse-watch/releases/tag/v0.3.0) and extract the entire ZIP. Google platform-tools are already included.

Put your Watch5 Pro and computer on the same home Wi-Fi. Enable ADB debugging and Wireless debugging in watch Developer options. Double-click Install.cmd in the extracted folder.

When asked for the pairing address, open Pair new device on the watch and enter that screen's IP:port. Enter its six-digit code when ADB asks. Keep the pairing screen open until pairing succeeds. If this computer is already paired, press Enter to skip this step.

Return to the main Wireless debugging screen and enter its connection IP:port at the next prompt. It uses a different port. The helper checks for a Watch5 Pro and installs without clearing app data.

Optionally enter Y for token setup and enter your own token in the hidden prompt. It is sent through stdin to app-private storage, imported into encrypted storage, and deleted from its temporary provisioning file. Or skip token setup and enter it on the watch later.

The helper opens Muse Watch. Choose Setup > Pair / reconnect, then add the matching gadget from Muse > Settings > Devices on your phone, with Developer mode enabled.

PowerShell execution-policy bypass applies only to this process; your permanent execution policy is unchanged. The project owner reports successful use of this workflow; the script was not executed on Windows in the cloud build session. On other watch models use manual ADB as explained in WATCH-SETUP.md.

For future updates, use the same-signed APK and skip token provisioning to preserve pairing. Turn off wireless debugging after installation. Never post your token or pairing code in issue reports.
