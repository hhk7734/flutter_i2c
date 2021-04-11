/*
 * MIT License
 * Copyright (c) 2021 Hyeonki Hong <hhk7734@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'bindings.g.dart';

LibLotI2c? _libLotI2c;
LibLotI2c get libLotI2c {
  final path = Platform.environment['LIBLOT_I2C_PATH'];
  return _libLotI2c ??= path != null
      ? LibLotI2c(ffi.DynamicLibrary.open(path))
      : LibLotI2c(ffi.DynamicLibrary.process());
}

class I2c {
  final String device;
  late final int fd;
  final _native = libLotI2c;

  I2c(this.device);

  I2c.fromBusNumber(int busNumber) : this('/dev/i2c-$busNumber');

  bool init() {
    final cDevice = device.toNativeUtf8();
    fd = _native.lot_i2c_init(cDevice.cast<ffi.Int8>());
    return fd >= 0 ? true : false;
  }

  void dispose() {
    if (fd >= 0) _native.lot_i2c_dispose(fd);
  }
}
