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

  void dispose() {
    FlutterI2c.dispose(_fd);
  }
}
