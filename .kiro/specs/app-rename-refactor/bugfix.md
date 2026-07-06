# Bugfix Requirements Document

## Introduction

The Flutter calculator app is branded "Pastel Calc" but its package name, folder name, bundle identifier, and several configuration files still reference the legacy development name "harshiapp". This inconsistency causes confusion during development, produces misleading bundle identifiers in builds, and shows the wrong name in the iOS app launcher. The fix renames all references from "harshiapp" to "pastelcalc" across the entire project.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the project is built THEN the system uses the package name `harshiapp` in pubspec.yaml despite the app being branded "Pastel Calc"

1.2 WHEN test files import project modules THEN the system uses `package:harshiapp/` import paths that contradict the app's identity

1.3 WHEN the iOS app is installed on a device THEN the system displays "harshiapp" as the CFBundleName in Info.plist

1.4 WHEN the iOS app is submitted or identified THEN the system uses the bundle identifier `com.example.harshiapp` which does not reflect the product name

1.5 WHEN a developer opens the project in an IDE THEN the system references the root folder `/Users/hdev/Dev/harshiapp/` and the module file `harshiapp.iml`, both using the legacy name

1.6 WHEN the iOS build system generates configuration THEN the system writes paths containing `harshiapp` in Generated.xcconfig, flutter_native_integration.env, and flutter_export_environment.sh

### Expected Behavior (Correct)

2.1 WHEN the project is built THEN the system SHALL use the package name `pastelcalc` in pubspec.yaml

2.2 WHEN test files import project modules THEN the system SHALL use `package:pastelcalc/` import paths

2.3 WHEN the iOS app is installed on a device THEN the system SHALL display "Pastel Calc" as the CFBundleName in Info.plist

2.4 WHEN the iOS app is submitted or identified THEN the system SHALL use the bundle identifier `com.example.pastelcalc`

2.5 WHEN a developer opens the project in an IDE THEN the system SHALL reference the root folder as `pastelcalc/` and the module file as `pastelcalc.iml`

2.6 WHEN the iOS build system generates configuration THEN the system SHALL write paths containing `pastelcalc` in Generated.xcconfig, flutter_native_integration.env, and flutter_export_environment.sh (these are auto-regenerated on next build after the folder rename)

### Unchanged Behavior (Regression Prevention)

3.1 WHEN the user taps calculator buttons THEN the system SHALL CONTINUE TO perform arithmetic calculations correctly

3.2 WHEN the user views the app title bar THEN the system SHALL CONTINUE TO display "Pastel Calc" as the MaterialApp title

3.3 WHEN the app accesses calculation history via shared_preferences THEN the system SHALL CONTINUE TO persist and retrieve history entries correctly

3.4 WHEN the project is compiled THEN the system SHALL CONTINUE TO resolve all dependencies (cupertino_icons, shared_preferences, uuid) without errors

3.5 WHEN the app renders the UI THEN the system SHALL CONTINUE TO use the Nunito font family from bundled assets

3.6 WHEN tests are executed THEN the system SHALL CONTINUE TO pass with the updated import paths
