#include "include/flutter_i2c/flutter_i2c_method.h"

#include "include/flutter_i2c/flutter_i2c_plugin.h"

#include <cerrno>     //errno
#include <cstring>    // strerror
#include <fcntl.h>    // open()
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <sys/ioctl.h>    // ioctl()
#include <unistd.h>       // close()

namespace flutter_i2c {
FlMethodResponse *init(FlValue *args) {
    int fd = open(fl_value_get_string(args), O_RDWR);
    if(fd < 0) {
        return FL_METHOD_RESPONSE(fl_method_error_response_new(
            kRuntimeError, strerror(errno), nullptr));
    }

    return FL_METHOD_RESPONSE(
        fl_method_success_response_new(fl_value_new_int(fd)));
}

FlMethodResponse *dispose(FlValue *args) {
    close(fl_value_get_int(args));
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse *transmit(FlValue *args) {
    struct i2c_rdwr_ioctl_data i2c;
    struct i2c_msg             msgs;
    int      fd   = fl_value_get_int(fl_value_get_list_value(args, 0));
    int      addr = fl_value_get_int(fl_value_get_list_value(args, 1));
    uint8_t *buf  = const_cast<uint8_t *>(
        fl_value_get_uint8_list(fl_value_get_list_value(args, 2)));
    int len = fl_value_get_int(fl_value_get_list_value(args, 3));

    msgs.addr  = addr;
    msgs.flags = 0;
    msgs.len   = len;
    msgs.buf   = buf;

    i2c.msgs  = &msgs;
    i2c.nmsgs = 1;

    ioctl(fd, I2C_RDWR, &i2c);

    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}
}    // namespace flutter_i2c
