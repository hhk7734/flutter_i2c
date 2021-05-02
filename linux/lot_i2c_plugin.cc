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

#include "include/lot_i2c/lot_i2c_plugin.h"

#include "lot_i2c/lot_i2c.h"

#include <cstdlib>    // free(), malloc()
#include <cstring>
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#define LOT_I2C_PLUGIN(obj) \
    (G_TYPE_CHECK_INSTANCE_CAST((obj), lot_i2c_plugin_get_type(), LotI2cPlugin))

struct _LotI2cPlugin {
    GObject parent_instance;
};

G_DEFINE_TYPE(LotI2cPlugin, lot_i2c_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void lot_i2c_plugin_handle_method_call(LotI2cPlugin *self,
                                              FlMethodCall *method_call) {
    const gchar *method = fl_method_call_get_name(method_call);
    FlValue *    args   = fl_method_call_get_args(method_call);

    g_autoptr(FlMethodResponse) response = nullptr;

    if(strcmp(method, kInitMethod) == 0) {
        int fd = lot_i2c_init(fl_value_get_string(args));
        if(fd < 0) {
            return FL_METHOD_RESPONSE(fl_method_error_response_new(
                kRuntimeError, strerror(errno), nullptr));
        }

        response = FL_METHOD_RESPONSE(
            fl_method_success_response_new(fl_value_new_int(fd)));
    } else if(strcmp(method, kDisposeMethod) == 0) {
        lot_i2c_dispose(fl_value_get_int(args));

        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if(strcmp(method, kTransmitMethod) == 0) {
        int      fd     = fl_value_get_int(fl_value_get_list_value(args, 0));
        int      addr   = fl_value_get_int(fl_value_get_list_value(args, 1));
        uint8_t *tx_buf = const_cast<uint8_t *>(
            fl_value_get_uint8_list(fl_value_get_list_value(args, 2)));
        int tx_size = fl_value_get_length(fl_value_get_list_value(args, 2));

        lot_i2c_transmit(fd, addr, tx_buf, tx_size);

        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if(strcmp(method, kReceiveMethod) == 0) {
        int      fd      = fl_value_get_int(fl_value_get_list_value(args, 0));
        int      addr    = fl_value_get_int(fl_value_get_list_value(args, 1));
        int      rx_size = fl_value_get_int(fl_value_get_list_value(args, 2));
        uint8_t *rx_buf  = (uint8_t *)malloc(rx_size);

        lot_i2c_receive(fd, addr, rx_buf, rx_size);

        g_autoptr(FlValue) value = fl_value_new_uint8_list(rx_buf, rx_size);
        free(rx_buf);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(value));
    } else if(strcmp(method, kTransceiveMethod) == 0) {
        int      fd     = fl_value_get_int(fl_value_get_list_value(args, 0));
        int      addr   = fl_value_get_int(fl_value_get_list_value(args, 1));
        uint8_t *tx_buf = const_cast<uint8_t *>(
            fl_value_get_uint8_list(fl_value_get_list_value(args, 2)));
        int tx_size     = fl_value_get_length(fl_value_get_list_value(args, 2));
        int rx_size     = fl_value_get_int(fl_value_get_list_value(args, 3));
        uint8_t *rx_buf = (uint8_t *)malloc(rx_size);

        lot_i2c_transceive(fd, addr, tx_buf, tx_size, rx_buf, rx_size);

        g_autoptr(FlValue) value = fl_value_new_uint8_list(rx_buf, rx_size);
        free(rx_buf);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(value));
    } else {
        response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    }

    g_autoptr(GError) error = nullptr;
    if(! fl_method_call_respond(method_call, response, &error)) {
        g_warning("Failed to send method call response: %s", error->message);
    }
}

static void lot_i2c_plugin_dispose(GObject *object) {
    G_OBJECT_CLASS(lot_i2c_plugin_parent_class)->dispose(object);
}

static void lot_i2c_plugin_class_init(LotI2cPluginClass *klass) {
    G_OBJECT_CLASS(klass)->dispose = lot_i2c_plugin_dispose;
}

static void lot_i2c_plugin_init(LotI2cPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel,
                           FlMethodCall *   method_call,
                           gpointer         user_data) {
    LotI2cPlugin *plugin = LOT_I2C_PLUGIN(user_data);
    lot_i2c_plugin_handle_method_call(plugin, method_call);
}

static gchar *get_executable_dir() {
    g_autoptr(GError) error    = nullptr;
    g_autofree gchar *exe_path = g_file_read_link("/proc/self/exe", &error);
    if(exe_path == nullptr) {
        g_critical("Failed to determine location of executable: %s",
                   error->message);
        return nullptr;
    }

    return g_path_get_dirname(exe_path);
}


void lot_i2c_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
    LotI2cPlugin *plugin
        = LOT_I2C_PLUGIN(g_object_new(lot_i2c_plugin_get_type(), nullptr));

    g_autofree gchar *executable_dir = get_executable_dir();
    g_autofree gchar *liblot_i2c_path
        = g_build_filename(executable_dir, "lib", "liblot_i2c.so", nullptr);
    setenv("LIBLOT_I2C_PATH", liblot_i2c_path, 0);

    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    g_autoptr(FlMethodChannel) channel
        = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                                kChannelName,
                                FL_METHOD_CODEC(codec));
    fl_method_channel_set_method_call_handler(
        channel, method_call_cb, g_object_ref(plugin), g_object_unref);

    g_object_unref(plugin);
}
