#pragma once

#include "flutter_i2c_plugin.h"

#include <flutter_linux/flutter_linux.h>

const char kChannelName[] = "flutter_i2c";

const char kRuntimeError[] = "Runtime Error";

const char kInitMethod[]       = "init";
const char kDisposeMethod[]    = "dispose";
const char kTransmitMethod[]   = "transmit";
const char kReceiveMethod[]    = "receive";
const char kTransceiveMethod[] = "transceive";

namespace flutter_i2c {
/**
 * @param args int fd
 */
FlMethodResponse *init(FlValue *args);

/**
 * @param args int fd
 */
FlMethodResponse *dispose(FlValue *args);

/**
 * @param args 0: int fd
 * @param args 1: int slaveAddress
 * @param args 2: Uint8List byteData
 */
FlMethodResponse *transmit(FlValue *args);

/**
 * @param args 0: int fd
 * @param args 1: int slaveAddress
 * @param args 2: int size
 */
FlMethodResponse *receive(FlValue *args);

/**
 * @param args 0: int fd
 * @param args 1: int slaveAddress
 * @param args 2: Uint8List txByteData
 * @param args 3: int rxSize
 */
FlMethodResponse *transceive(FlValue *args);
}    // namespace flutter_i2c