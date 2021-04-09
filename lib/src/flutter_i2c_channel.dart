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
import 'dart:async';

import 'package:flutter/services.dart';

const String _flutterI2cChannelName = 'flutter_i2c';

const String _initMethod = 'init';
const String _disposeMethod = 'dispose';

class FlutterI2c {
  /// Private constructor.
  FlutterI2c._();

  static const MethodChannel _channel = MethodChannel(_flutterI2cChannelName);

  static Future<int> init(String device) async {
    try {
      final fd = await _channel.invokeMethod(_initMethod, device);
      return fd;
    } on PlatformException catch (e) {
      throw 'Failed to open $device: ${e.message}';
    }
  }

  static Future<void> dispose(int fd) async {
    await _channel.invokeMethod(_disposeMethod, fd);
  }

  static Future<String> get platformVersion async {
    final version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
