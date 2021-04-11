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
#include "lot_i2c.h"

#include <fcntl.h>    // open()
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <sys/ioctl.h>    // ioctl()
#include <unistd.h>       // close()

int lot_i2c_init(const char *device) { return open(device, O_RDWR); }

void lot_i2c_dispose(int fd) { close(fd); }

void lot_i2c_transmit(int fd, int slaveAddress, uint8_t *tx_buf, int tx_size) {
    struct i2c_rdwr_ioctl_data i2c;
    struct i2c_msg             msgs;

    msgs.addr  = slaveAddress;
    msgs.flags = 0;
    msgs.len   = tx_size;
    msgs.buf   = tx_buf;

    i2c.msgs  = &msgs;
    i2c.nmsgs = 1;

    ioctl(fd, I2C_RDWR, &i2c);
}

void lot_i2c_receive(int fd, int slaveAddress, uint8_t *rx_buf, int rx_size) {
    struct i2c_rdwr_ioctl_data i2c;
    struct i2c_msg             msgs;

    msgs.addr  = slaveAddress;
    msgs.flags = I2C_M_RD;    // read
    msgs.len   = rx_size;
    msgs.buf   = rx_buf;

    i2c.msgs  = &msgs;
    i2c.nmsgs = 1;

    ioctl(fd, I2C_RDWR, &i2c);
}

void lot_i2c_transceive(int      fd,
                        int      slaveAddress,
                        uint8_t *tx_buf,
                        int      tx_size,
                        uint8_t *rx_buf,
                        int      rx_size) {
    struct i2c_rdwr_ioctl_data i2c;
    struct i2c_msg             msgs[2];

    msgs[0].addr  = slaveAddress;
    msgs[0].flags = 0;    // write
    msgs[0].len   = tx_size;
    msgs[0].buf   = tx_buf;

    msgs[1].addr  = slaveAddress;
    msgs[1].flags = I2C_M_RD;    // read
    msgs[1].len   = rx_size;
    msgs[1].buf   = rx_buf;

    i2c.msgs  = msgs;
    i2c.nmsgs = 2;

    ioctl(fd, I2C_RDWR, &i2c);
}