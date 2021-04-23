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
import 'dart:typed_data';

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
  String device;
  int _fd = -1;
  final _native = libLotI2c;

  I2c(this.device);

  I2c.fromBusNumber(int busNumber) : this('/dev/i2c-$busNumber');

  int get fd => _fd;

  bool init() {
    final cDevice = device.toNativeUtf8();
    _fd = _native.init(cDevice.cast<ffi.Int8>());
    return _fd >= 0 ? true : false;
  }

  void transmit(int slaveAddress, Uint8List txBuf) {
    final _txBuf = malloc.allocate<ffi.Uint8>(txBuf.length);
    var index = 0;

    for (var value in txBuf) {
      _txBuf[index++] = value;
    }

    _native.transmit(_fd, slaveAddress, _txBuf, txBuf.length);

    malloc.free(_txBuf);
  }

  Uint8List receive(int slaveAddress, int rxSize) {
    final _rxBuf = malloc.allocate<ffi.Uint8>(rxSize);
    final rxBuf = Uint8List(rxSize);

    _native.receive(_fd, slaveAddress, _rxBuf, rxSize);

    for (var index = 0; index < rxSize; index++) {
      rxBuf[index] = _rxBuf[index];
    }

    malloc.free(_rxBuf);

    return rxBuf;
  }

  Uint8List transceive(int slaveAddress, Uint8List txBuf, int rxSize) {
    final _txBuf = malloc.allocate<ffi.Uint8>(txBuf.length);
    final _rxBuf = malloc.allocate<ffi.Uint8>(rxSize);
    final rxBuf = Uint8List(rxSize);
    var index = 0;

    for (var value in txBuf) {
      _txBuf[index++] = value;
    }

    _native.transceive(_fd, slaveAddress, _txBuf, txBuf.length, _rxBuf, rxSize);

    for (var index = 0; index < rxSize; index++) {
      rxBuf[index] = _rxBuf[index];
    }

    malloc.free(_txBuf);
    malloc.free(_rxBuf);

    return rxBuf;
  }

  void writeByteReg(int slaveAddress, int register, int value) {
    final _txBuf = malloc.allocate<ffi.Uint8>(2);

    _txBuf[0] = register;
    _txBuf[1] = value;

    _native.transmit(_fd, slaveAddress, _txBuf, 2);

    malloc.free(_txBuf);
  }

  void writeByteListReg(int slaveAddress, int register, Uint8List txBuf) {
    final _txBuf = malloc.allocate<ffi.Uint8>(txBuf.length + 1);
    var index = 0;

    _txBuf[index++] = register;
    for (var value in txBuf) {
      _txBuf[index++] = value;
    }

    _native.transmit(_fd, slaveAddress, _txBuf, index);

    malloc.free(_txBuf);
  }

  int readByteReg(int slaveAddress, int register) {
    final _buf = malloc.allocate<ffi.Uint8>(1);

    _buf.value = register;

    _native.transceive(_fd, slaveAddress, _buf, 1, _buf, 1);

    final rxBuf = _buf.value;

    malloc.free(_buf);

    return rxBuf;
  }

  Uint8List readByteListReg(int slaveAddress, int register, int rxSize) {
    final _buf = malloc.allocate<ffi.Uint8>(rxSize);
    final rxBuf = Uint8List(rxSize);

    _buf.value = register;

    _native.transceive(_fd, slaveAddress, _buf, 1, _buf, rxSize);

    for (var index = 0; index < rxSize; index++) {
      rxBuf[index] = _buf[index];
    }

    malloc.free(_buf);

    return rxBuf;
  }

  void dispose() {
    if (_fd >= 0) {
      _native.dispose(_fd);
      _fd = -1;
    }
  }
}
