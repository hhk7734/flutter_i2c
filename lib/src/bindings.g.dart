// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings to `liblot_i2c`
class LibLotI2c {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  LibLotI2c(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  LibLotI2c.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int lot_i2c_init(
    ffi.Pointer<ffi.Int8> device,
  ) {
    return _lot_i2c_init(
      device,
    );
  }

  late final _lot_i2c_init_ptr =
      _lookup<ffi.NativeFunction<_c_lot_i2c_init>>('lot_i2c_init');
  late final _dart_lot_i2c_init _lot_i2c_init =
      _lot_i2c_init_ptr.asFunction<_dart_lot_i2c_init>();

  void lot_i2c_dispose(
    int fd,
  ) {
    return _lot_i2c_dispose(
      fd,
    );
  }

  late final _lot_i2c_dispose_ptr =
      _lookup<ffi.NativeFunction<_c_lot_i2c_dispose>>('lot_i2c_dispose');
  late final _dart_lot_i2c_dispose _lot_i2c_dispose =
      _lot_i2c_dispose_ptr.asFunction<_dart_lot_i2c_dispose>();
}

typedef _c_lot_i2c_init = ffi.Int32 Function(
  ffi.Pointer<ffi.Int8> device,
);

typedef _dart_lot_i2c_init = int Function(
  ffi.Pointer<ffi.Int8> device,
);

typedef _c_lot_i2c_dispose = ffi.Void Function(
  ffi.Int32 fd,
);

typedef _dart_lot_i2c_dispose = void Function(
  int fd,
);
