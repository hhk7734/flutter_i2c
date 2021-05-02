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
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

const String _kChannelName = 'lot_i2c';

const String _kInitMethod = 'init';
const String _kDisposeMethod = 'dispose';
const String _kTransmitMethod = 'transmit';
const String _kReceiveMethod = 'receive';
const String _kTransceiveMethod = 'transceive';

class LotI2cChannel {
  /// Private constructor.
  LotI2cChannel._();

  static const MethodChannel _channel = MethodChannel(_kChannelName);

  static Future<int> init(String device) async {
    try {
      final fd = await _channel.invokeMethod(_kInitMethod, device);
      return fd;
    } on PlatformException catch (e) {
      throw 'Failed to open $device: ${e.message}';
    }
  }

  static Future<void> transmit(
      int fd, int slaveAddress, Uint8List txBuf) async {
    await _channel.invokeMethod(
        _kTransmitMethod, [fd, slaveAddress, txBuf, txBuf.length]);
  }

  static Future<Uint8List> receive(int fd, int slaveAddress, int rxSize) async {
    final rxBuf = await _channel
        .invokeMethod(_kReceiveMethod, [fd, slaveAddress, rxSize]);
    return rxBuf;
  }

  static Future<Uint8List> transceive(
      int fd, int slaveAddress, Uint8List txBuf, int rxSize) async {
    final rxBuf = await _channel.invokeMethod(
        _kTransceiveMethod, [fd, slaveAddress, txBuf, txBuf.length, rxSize]);
    return rxBuf;
  }

  static Future<void> dispose(int fd) async {
    await _channel.invokeMethod(_kDisposeMethod, fd);
  }
}
