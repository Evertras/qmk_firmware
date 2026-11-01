# OLED art

- `left.png`: shown on the left OLED (the half plugged into USB).
- `right.png`: shown on the right OLED.

Both screens are mounted vertically, so each image must be exactly **32×128 pixels** (tall). Draw it the way you want it to look on the keyboard, with the top of the image towards the number row. `build-mackenzie` rotates each one to suit how its screen is mounted.

Pixels with brightness 128 or more are lit, anything darker is off, so draw white on black. Flatten the image before exporting so there are no transparent pixels.

To change the art, replace a PNG and run `build-mackenzie` (inside `nix develop`). It regenerates `left_logo.h` and `right_logo.h` in the keymap folder from these images before building. Don't edit those headers by hand, as the next build overwrites them.

To convert a single image yourself, from the keymap folder:

```
png2oled art/left.png left_logo left_logo.h cw
png2oled art/right.png right_logo right_logo.h ccw
```

`cw` and `ccw` are needed because the two screens face opposite ways. Without a rotation, `png2oled` expects a 128×32 image and converts it as-is.
