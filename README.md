# Hero Widget Demo

A Flutter demo showcasing custom `Hero` flight animations — rotate, scale-bounce, and fade-through — beyond the default rectangle morph.

## Run Instructions

```bash
flutter pub get
flutter run
```

Tap any tile on the gallery grid to see its Hero transition to the detail screen; tap **Back** to reverse it.

## The Three Attributes

- **`tag`** — Uniquely identifies matching Hero widgets across two screens (e.g. `'item-${item.title}'`). Flutter uses this to know which widgets to link for the flight animation.
- **`child`** — The widget actually displayed on each screen (here, a colored, rounded container with an icon). Its size/shape differs between screens, and Hero morphs between the two.
- **`flightShuttleBuilder`** — Overrides the widget shown *during* the transition itself, letting you swap in a custom animation (rotation, scale bounce, fade) instead of the default morph.

## Screenshot

![Hero Widget Demo UI](screenshots/hero_demo.png)
