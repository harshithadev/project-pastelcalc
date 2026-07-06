# App Rename Refactor Bugfix Design

## Overview

The Flutter calculator app is branded "Pastel Calc" but project-level configuration still uses the legacy name "harshiapp" in the package name, imports, iOS bundle identifier, iOS Info.plist, IDE module file, and folder name. This creates confusion for developers and produces incorrect metadata in built artifacts. The fix performs a systematic rename from "harshiapp" to "pastelcalc" across all configuration surfaces while leaving runtime behavior completely unchanged.

## Glossary

- **Bug_Condition (C)**: Any configuration file, import path, or project reference that contains the string "harshiapp" where it should read "pastelcalc"
- **Property (P)**: After the fix, all project configuration surfaces use "pastelcalc" as the package/project name, and the iOS display name reads "Pastel Calc"
- **Preservation**: All runtime behavior (calculations, UI rendering, history persistence, font loading, dependency resolution) remains unchanged
- **pubspec.yaml**: The Flutter project manifest at the repository root that declares the package `name` field
- **CFBundleName**: The iOS Info.plist key that sets the short app name shown in certain system contexts
- **PRODUCT_BUNDLE_IDENTIFIER**: The Xcode build setting that defines the unique app identifier for iOS

## Bug Details

### Bug Condition

The bug manifests when any tooling, build system, or developer inspects project metadata and encounters "harshiapp" instead of the expected "pastelcalc". This affects the Dart package name, import URIs, iOS bundle identifier, iOS display name, IDE module file, and the project folder name.

**Formal Specification:**
```
FUNCTION isBugCondition(input)
  INPUT: input of type ProjectFile
  OUTPUT: boolean

  RETURN input.containsString("harshiapp")
         AND input.path IN [
           "pubspec.yaml",
           "test/*.dart (import statements)",
           "ios/Runner/Info.plist (CFBundleName)",
           "ios/Runner.xcodeproj/project.pbxproj (PRODUCT_BUNDLE_IDENTIFIER)",
           "harshiapp.iml",
           "ios/Flutter/Generated.xcconfig (auto-regenerated paths)"
         ]
END FUNCTION
```

### Examples

- **pubspec.yaml**: `name: harshiapp` → expected: `name: pastelcalc`
- **test/widget_test.dart**: `import 'package:harshiapp/main.dart'` → expected: `import 'package:pastelcalc/main.dart'`
- **test/calculator_test.dart**: `import 'package:harshiapp/models/complex_number.dart'` → expected: `import 'package:pastelcalc/models/complex_number.dart'`
- **ios/Runner/Info.plist CFBundleName**: `<string>harshiapp</string>` → expected: `<string>Pastel Calc</string>`
- **ios project.pbxproj**: `PRODUCT_BUNDLE_IDENTIFIER = com.example.harshiapp` → expected: `PRODUCT_BUNDLE_IDENTIFIER = com.example.pastelcalc`
- **harshiapp.iml**: File should be renamed to `pastelcalc.iml` (content uses `$MODULE_DIR$` so no internal changes needed)

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- Calculator arithmetic (addition, subtraction, multiplication, division, complex numbers) must produce identical results
- The MaterialApp title "Pastel Calc" displayed in the title bar must remain unchanged
- Shared_preferences-based history persistence must continue to store and retrieve entries
- All dependencies (cupertino_icons, shared_preferences, uuid) must resolve without errors
- The Nunito font family from bundled assets must continue rendering correctly
- All existing tests must pass with updated import paths

**Scope:**
All runtime code paths are unaffected by this fix. The changes are purely in configuration metadata and import URIs. Specifically unaffected:
- `lib/` source files (no internal references to the package name)
- Widget rendering and layout logic
- Calculator engine evaluation
- Theme and styling
- Asset loading (fonts are referenced by relative path in pubspec.yaml)

## Hypothesized Root Cause

Based on the bug description, the root cause is straightforward:

1. **Initial Project Scaffolding**: The project was created with `flutter create harshiapp`, which set the package name, folder name, bundle identifier, and module file to "harshiapp" throughout

2. **Incomplete Rename**: The app was rebranded to "Pastel Calc" at the Dart source level (class name `PastelCalcApp`, MaterialApp title, theme naming) but the project-level configuration was never updated to match

3. **No Automated Rename Tool Used**: Flutter does not provide a built-in command to rename a project after creation; this requires manual edits across multiple files and platforms

4. **Generated Files Propagate Legacy Name**: Build-generated files like `Generated.xcconfig` derive paths from the folder name, perpetuating the old name until the folder is renamed and a clean build is triggered

## Correctness Properties

Property 1: Bug Condition - All Configuration References Use pastelcalc

_For any_ project file where the bug condition holds (the file contains "harshiapp" in a package name, import path, bundle identifier, CFBundleName, or module file name context), the fixed project SHALL replace that reference with "pastelcalc" (or "Pastel Calc" for the display name in CFBundleName).

**Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5, 2.6**

Property 2: Preservation - Runtime Behavior Unchanged

_For any_ input that exercises runtime behavior (calculator operations, UI rendering, history access, dependency resolution, font loading, test execution), the fixed project SHALL produce exactly the same results as the original project, preserving all functional behavior.

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6**

## Fix Implementation

### Changes Required

Assuming our root cause analysis is correct:

**File**: `pubspec.yaml`

**Change**: Update `name` field
1. **Package Name**: Change `name: harshiapp` to `name: pastelcalc`

---

**File**: `test/widget_test.dart`

**Change**: Update import paths
1. **Import 1**: Change `import 'package:harshiapp/main.dart'` to `import 'package:pastelcalc/main.dart'`
2. **Import 2**: Change `import 'package:harshiapp/widgets/display_panel.dart'` to `import 'package:pastelcalc/widgets/display_panel.dart'`

---

**File**: `test/calculator_test.dart`

**Change**: Update import paths
1. **Import 1**: Change `import 'package:harshiapp/models/complex_number.dart'` to `import 'package:pastelcalc/models/complex_number.dart'`
2. **Import 2**: Change `import 'package:harshiapp/services/calculator_engine.dart'` to `import 'package:pastelcalc/services/calculator_engine.dart'`

---

**File**: `ios/Runner/Info.plist`

**Change**: Update CFBundleName
1. **Display Name**: Change `<string>harshiapp</string>` (under CFBundleName) to `<string>Pastel Calc</string>`

---

**File**: `ios/Runner.xcodeproj/project.pbxproj`

**Change**: Update bundle identifiers
1. **Main App**: Change `PRODUCT_BUNDLE_IDENTIFIER = com.example.harshiapp` to `PRODUCT_BUNDLE_IDENTIFIER = com.example.pastelcalc` (3 occurrences)
2. **Tests**: Change `PRODUCT_BUNDLE_IDENTIFIER = com.example.harshiapp.RunnerTests` to `PRODUCT_BUNDLE_IDENTIFIER = com.example.pastelcalc.RunnerTests` (3 occurrences)

---

**File**: `macos/Runner.xcodeproj/project.pbxproj`

**Change**: Update bundle identifiers
1. **Tests**: Change `PRODUCT_BUNDLE_IDENTIFIER = com.example.harshiapp.RunnerTests` to `PRODUCT_BUNDLE_IDENTIFIER = com.example.pastelcalc.RunnerTests` (3 occurrences)

---

**File**: `harshiapp.iml`

**Change**: Rename file
1. **Rename**: Rename `harshiapp.iml` to `pastelcalc.iml` (file content uses `$MODULE_DIR$` variables so no internal edits needed)

---

**Post-Fix Step**: Run `flutter pub get` to regenerate `.dart_tool/package_config.json` with the new package name. The iOS `Generated.xcconfig` and related files will be regenerated on the next `flutter build ios` or `flutter run` with updated paths after the folder rename.

## Testing Strategy

### Validation Approach

The testing strategy follows a two-phase approach: first, surface counterexamples that demonstrate the naming inconsistency in the unfixed project, then verify the fix resolves all references and preserves runtime behavior.

### Exploratory Bug Condition Checking

**Goal**: Surface counterexamples that demonstrate the legacy "harshiapp" name is still present BEFORE implementing the fix. Confirm the full scope of files that need updating.

**Test Plan**: Search the project for all occurrences of "harshiapp" in configuration files and verify each is a rename target. Run on the UNFIXED code to catalog all instances.

**Test Cases**:
1. **Package Name Test**: Verify `pubspec.yaml` contains `name: harshiapp` (will confirm bug on unfixed code)
2. **Import Path Test**: Verify test files contain `package:harshiapp/` imports (will confirm bug on unfixed code)
3. **Bundle Identifier Test**: Verify project.pbxproj contains `com.example.harshiapp` (will confirm bug on unfixed code)
4. **Info.plist Test**: Verify CFBundleName is "harshiapp" instead of "Pastel Calc" (will confirm bug on unfixed code)
5. **Module File Test**: Verify `harshiapp.iml` exists with that name (will confirm bug on unfixed code)

**Expected Counterexamples**:
- All five test cases will find "harshiapp" in the unfixed code
- The Generated.xcconfig paths also contain "harshiapp" but are auto-regenerated

### Fix Checking

**Goal**: Verify that for all project files where the bug condition holds, the fixed project uses "pastelcalc" (or "Pastel Calc" for the display name).

**Pseudocode:**
```
FOR ALL file WHERE isBugCondition(file) DO
  result := readFile_fixed(file)
  ASSERT NOT result.containsString("harshiapp")
  ASSERT result.containsExpectedReplacement("pastelcalc" OR "Pastel Calc")
END FOR
```

### Preservation Checking

**Goal**: Verify that for all runtime behaviors, the fixed project produces the same results as the original.

**Pseudocode:**
```
FOR ALL input WHERE NOT isBugCondition(input) DO
  ASSERT runtimeBehavior_original(input) = runtimeBehavior_fixed(input)
END FOR
```

**Testing Approach**: Property-based testing is recommended for preservation checking because:
- It can generate many calculator expressions to verify arithmetic is unchanged
- It catches edge cases in expression evaluation that manual tests might miss
- It provides strong guarantees that the rename had no effect on runtime behavior

**Test Plan**: Run the existing test suite on the FIXED code to verify all calculator logic, widget rendering, and complex number operations still pass with updated import paths.

**Test Cases**:
1. **Arithmetic Preservation**: Verify basic arithmetic (add, subtract, multiply, divide) produces same results after rename
2. **Complex Number Preservation**: Verify complex number operations (i*i = -1, conjugates, division) work identically
3. **Widget Rendering Preservation**: Verify PastelCalcApp widget launches and displays "Pastel Calc" title
4. **Dependency Resolution Preservation**: Verify `flutter pub get` succeeds with the new package name
5. **Font Loading Preservation**: Verify Nunito font assets are still correctly referenced and loadable

### Unit Tests

- Test that `flutter pub get` resolves all dependencies with `name: pastelcalc`
- Test that all existing calculator_test.dart tests pass with updated imports
- Test that widget_test.dart launches the app successfully with updated imports
- Test that no "harshiapp" string remains in any tracked configuration file

### Property-Based Tests

- Generate random arithmetic expressions and verify the calculator engine evaluates them identically before and after the rename
- Generate random complex number inputs and verify operations produce identical results
- Test import resolution across many possible file paths to ensure no broken references

### Integration Tests

- Full build cycle: `flutter pub get` → `flutter build ios` succeeds without errors
- Run full test suite: `flutter test` passes with zero failures
- Verify iOS simulator launch displays "Pastel Calc" as the app name
