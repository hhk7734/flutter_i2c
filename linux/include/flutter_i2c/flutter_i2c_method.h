#pragma once

#include "flutter_i2c_plugin.h"

#include <flutter_linux/flutter_linux.h>

const char kChannelName[] = "flutter_i2c";

const char kRuntimeError[] = "Runtime Error";

const char kInitMethod[]     = "init";
const char kDisposeMethod[]  = "dispose";
const char kTransmitMethod[] = "transmit";
const char kReceiveMethod[]  = "receive";

namespace flutter_i2c {
FlMethodResponse *init(FlValue *args);
FlMethodResponse *dispose(FlValue *args);
FlMethodResponse *transmit(FlValue *args);
FlMethodResponse *receive(FlValue *args);
}    // namespace flutter_i2c