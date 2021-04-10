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