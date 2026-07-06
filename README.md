# Pastel Calc

A playful, fully offline Flutter calculator with a soft pastel theme, haptic feedback, and complex-number support.

## Features

- **Arithmetic** — addition, subtraction, multiplication, division
- **Complex numbers** — use `i` for √−1 (e.g. `3+4i`, `(1+i)*(1-i)`, `i*i`)
- **History** — every calculation is saved locally; swipe to delete, tap to reuse, clear all
- **Haptics** — light taps on keys, stronger feedback on equals and errors
- **Pastel UI** — soft mint, lavender, peach, and rose buttons with bundled Nunito font
- **Privacy-first** — no network, no analytics, no tracking; data stays on your device

## Run

```bash
flutter pub get
flutter run
```

## Try it

| Expression | Result |
|-----------|--------|
| `2+3` | `5` |
| `6×7` | `42` |
| `i*i` | `-1` |
| `(1+i)*(1-i)` | `2` |
| `3+4i` | `3+4i` |
