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
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
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
import 'dart:ffi';
import 'dart:typed_data';

import 'bindings.g.dart';
import 'lot_i2c_channel.dart';

LotI2cNative? _libLotI2c;
LotI2cNative get libLotI2c {
  final path = Platform.environment['LIBLOT_I2C_PATH'];
  return _libLotI2c ??= path != null
      ? LotI2cNative(DynamicLibrary.open(path))
      : LotI2cNative(DynamicLibrary.process());
}

class I2c {
  String device;
  int _fd = -1;

  I2c(this.device);

  I2c.fromBusNumber(int busNumber) : this('/dev/i2c-$busNumber');

  int get fd => _fd;

  Future<void> init() async {
    await dispose();
    _fd = await LotI2cChannel.init(device);
  }

  Future<void> transmit(int slaveAddress, Uint8List txBuf) async {
    await LotI2cChannel.transmit(_fd, slaveAddress, txBuf);
  }

  Future<Uint8List> receive(int slaveAddress, int rxSize) async {
    final rxBuf = await LotI2cChannel.receive(_fd, slaveAddress, rxSize);
    return rxBuf;
  }

  Future<Uint8List> transceive(
      int slaveAddress, Uint8List txBuf, int rxSize) async {
    final rxBuf =
        await LotI2cChannel.transceive(_fd, slaveAddress, txBuf, rxSize);
    return rxBuf;
  }

  Future<void> writeByteReg(int slaveAddress, int register, int value) async {
    await transmit(slaveAddress, Uint8List.fromList([register, value]));
  }

  Future<void> writeByteListReg(
      int slaveAddress, int register, Uint8List txBuf) async {
    final _txBuf = Uint8List.fromList([register]);
    _txBuf.addAll(txBuf);
    await transmit(slaveAddress, _txBuf);
  }

  Future<int> readByteReg(int slaveAddress, int register) async {
    final rxBuf =
        await transceive(slaveAddress, Uint8List.fromList([register]), 1);
    return rxBuf[0];
  }

  Future<Uint8List> readByteListReg(
      int slaveAddress, int register, int rxSize) async {
    final rxBuf =
        await transceive(slaveAddress, Uint8List.fromList([register]), rxSize);
    return rxBuf;
  }

  Future<void> dispose() async {
    if (_fd >= 0) {
      await LotI2cChannel.dispose(_fd);
      _fd = -1;
    }
  }
}
