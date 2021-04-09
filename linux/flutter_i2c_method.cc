#include "include/flutter_i2c/flutter_i2c_method.h"

#include "include/flutter_i2c/flutter_i2c_plugin.h"

#include <cerrno>      //errno
#include <cstring>     // strerror
#include <fcntl.h>     // open()
#include <unistd.h>    // close()

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
}    // namespace flutter_i2c
