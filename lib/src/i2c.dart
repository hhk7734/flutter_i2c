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

  void dispose() {
    FlutterI2c.dispose(_fd);
  }
}
