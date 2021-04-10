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
import 'dart:typed_data';

import 'flutter_i2c_channel.dart';

typedef OnI2cInitError = void Function(String errorMsg);

class I2c {
  final String _device;
  int _fd = -1;

  I2c(String device) : _device = device;

  I2c.fromBusNumber(int busNumber) : this('/dev/i2c-$busNumber');

  Future<bool> init({OnI2cInitError onError}) async {
    try {
      _fd = await FlutterI2c.init(_device);
      return true;
    } catch (e) {
      onError?.call(e);
      return false;
    }
  }

  Future<void> transmit(int slaveAddress, Uint8List byteData) async {
    await FlutterI2c.transmit(_fd, slaveAddress, byteData);
  }

  Future<Uint8List> receive(int slaveAddress, int size) async {
    final byteData = await FlutterI2c.receive(_fd, slaveAddress, size);
    return byteData;
  }

  Future<Uint8List> transceive(
      int slaveAddress, Uint8List txByteData, int rxSize) async {
    final byteDAta =
        await FlutterI2c.transceive(_fd, slaveAddress, txByteData, rxSize);
    return byteDAta;
  }

  void dispose() {
    FlutterI2c.dispose(_fd);
  }
}
