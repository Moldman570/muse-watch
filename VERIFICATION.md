# Muse Watch verification — October 10, 2026

- Debug APK compiled successfully for Android API 29+, targeting API 34, with Wear OS watch metadata and a launcher entry point.
- APK signature verification passed.
- All 34 JVM tests passed: pairing cryptography, Bluetooth framing, Noise sessions, message envelopes, reply/transcript matching, WAV encoding, display storage, and watch gestures.
- Three of these tests used Robolectric Android API 34 with a 225dp round-screen configuration. They checked that talk/setup controls fit the viewport, unpaired launch cannot record, and assistant-intent launch does not start a microphone. The token-entry test checks the password input type and transformation, screenshot protection, disabled saved state, and clearing on cancellation. These are simulated layout/lifecycle checks, not physical-watch tests or screenshots.
- Android lint passed with no errors. Two existing mixed-indentation findings in vendored cryptographic sources are narrowly excluded in app/lint.xml, leaving the upstream cryptography unchanged. The optional developer-token entry also has a scoped WearPasswordInput exception, because this sideloaded prototype offers manual SDK provisioning rather than companion authentication; see PHONE-START-HERE.md. Remaining warnings include English-only UI strings, synchronous preference writes, upstream mixed indentation, and newer dependency versions.
- Token-provision helper passed Python syntax/help and a mocked smoke check: explicit ADB target, token only through stdin, no token in command arguments or output. No actual ADB device operation was performed.
- git diff --check passed.

## Unverified on hardware

No physical Galaxy Watch was connected. No microphone recording, real Bluetooth pairing, real Muse message, watch speaker playback, or Samsung button remapping was executed in this cloud session.
Bluetooth LE peripheral availability, direct pairing, network routing, latency, and battery use need hands-on verification.
The experimental assistant entry point is implemented; becoming Samsung's long-press assistant and receiving hardware release events are not established. This build opens a foreground app and records with the onscreen button.

## Provenance

Adapted from cameronapak/muse-r1 commit c0dd741f0896f85540625d52be01750672e00eca.
Retains MIT first-party, Apache-2.0 Muse protocol, and MIT Noise notices in source.
Original r1 character artwork, Home launcher replacement, accessibility button interception, and firmware/keylayout modifications are removed.
No SDK token or account credential is included in the APK or source package.

## Version 0.2 phone-installation update

Added Setup > Add SDK token: optional password-masked, screenshot-protected token entry stored using the existing Android Keystore encryption. Computer provisioning remains available. APK signature matches the previous prototype, allowing in-place updates.
The phone installer workflow and token input on physical watch hardware have not been executed here.
The Windows PowerShell helper has been prepared but not executed on Windows.

## Wear OS emulator QA and version 0.3

Executed using the Test Android Apps emulator QA skill on an official Google Wear OS 6.0 / Android 16 (API 36) x86_64 system image, with a 454×454 circular display at 320dpi. This is a Google emulator, not Samsung One UI firmware.

The exact v0.2 delivery APK installed successfully and launched. UI-tree inspection and screenshots showed that the main controls fit the circular viewport; Hold to talk was disabled while unpaired, Setup was enabled, and holding the disabled control did not produce a recorded microphone-use entry. Setup and token-entry dialogs opened. The token field reached the curved edge and did not report password transformation in the accessibility tree.

Version 0.3 adds safe side margins to the token field and explicitly applies PasswordTransformationMethod after setSingleLine. The regression assertion, all 34 tests, lint, APK signature verification, and git diff --check passed. The v0.3 update installed successfully in place and its launcher and Setup menu were inspected.

The cloud host had no /dev/kvm. Software emulation took approximately 13 minutes to boot and encountered system-service and UI-automation timeouts. The disposable emulator's global watchdog timeout was extended to 600000ms, and cached processes were cleared during QA. These changes were confined to the emulator. Performance, latency, Bluetooth reliability, battery life, microphone capture, speaker replies, Samsung hardware shortcuts, and live Muse delivery were not validated.

The corrected token form's visual retest remains incomplete: subsequent UI-automation captures returned a null root and the simulator display was blank. No successful corrected-form screenshot or real token-save test is claimed. The initial form's SECURE window flags were inspected; emulator-console capture is a privileged display capture and is not proof that Android screenshot protection is absent.

## Owner-reported physical use — October 12, 2026

The project owner reports that the Windows installation workflow and app worked on their Galaxy Watch5 Pro / One UI Watch 8.0 and that the app feels responsive. They also report that holding the Home/power button opens the app. These are user reports, not cloud-observed hardware measurements. Hardware-button hold/release recording was investigated and deliberately left out at the owner's request; recording remains on the onscreen button.
