#!/usr/bin/env python3
"""Install/provision Muse Watch over an already authorized ADB connection."""
import argparse
import getpass
import pathlib
import subprocess
import sys

PACKAGE = "dev.community.musewatch"
ACTIVITY = "dev.cameronpak.muser1.MainActivity"

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--serial", required=True, help="Watch address/serial shown by adb devices")
    parser.add_argument("--apk", type=pathlib.Path, help="Optional APK to install/update, preserving app data")
    parser.add_argument("--token", action="store_true", help="Prompt privately for a Muse SDK token")
    args = parser.parse_args()
    adb = ["adb", "-s", args.serial]
    def run(*command, **kwargs):
        return subprocess.run(adb + list(command), check=True, **kwargs)
    try:
        if args.apk:
            if not args.apk.is_file():
                parser.error("APK file does not exist")
            run("install", "-r", str(args.apk))
        if args.token:
            run("shell", "am", "force-stop", PACKAGE)
            token = getpass.getpass("Muse SDK token (hidden): ").strip()
            if not token.startswith("mgst_") or len(token) > 16384:
                raise ValueError("Expected a Muse Gadget SDK token starting with mgst_.")
            run("shell", "run-as", PACKAGE, "sh", "-c",
                "'umask 077; mkdir -p files; cat > files/pending-sdk-token'",
                input=token.encode(), stdout=subprocess.DEVNULL)
            token = None
        run("shell", "am", "start", "-n", f"{PACKAGE}/{ACTIVITY}")
        if args.token:
            # Verify encryption/import without reading or printing the credential contents.
            import time
            time.sleep(2)
            run("shell", "run-as", PACKAGE, "sh", "-c",
                "'test ! -e files/pending-sdk-token && test -s no_backup/credentials.enc'")
            print("Encrypted token import verified. On the watch, tap Setup > Pair / reconnect.")
        else:
            print("Muse Watch opened. Updates preserve pairing when signed with the same key.")
    except FileNotFoundError:
        sys.exit("adb was not found. Install Android platform-tools and add them to PATH.")
    except (subprocess.CalledProcessError, ValueError):
        sys.exit("Setup did not complete. Check the selected watch, ADB authorization, APK signing key, and SDK token. No credentials were printed.")

if __name__ == "__main__":
    main()
