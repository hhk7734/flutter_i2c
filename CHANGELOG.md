## 0.3.0

- Change package name from `flutter_i2c` to `lot_i2c`
- lib: src: i2c: remove `final` from `device`
- lib: src: i2c: set `fd` to private and remove `final`
- lib: src: i2c: set `_fd` to -1 after `dispose()`
- lib: src: i2c: change `init()` from returning bool to throwing error

## 0.2.0

- lib: src: add `readByteReg()` and `readByteListReg()`
- lib: src: add `writeByteReg()` and `writeByteListReg()`
- ffigen: exclude all macro

## 0.1.0

- Change MethodChannel to ffi
- linux: lot_i2c: add `init()` and `dispose()`
- linux: lot_i2c: add `transmit()`, `receive()` and `transceive()`
