#include "include/flutter_i2c/flutter_i2c_plugin.h"

#include "include/flutter_i2c/flutter_i2c_method.h"

#include <cstring>
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#define FLUTTER_I2C_PLUGIN(obj)  \
    (G_TYPE_CHECK_INSTANCE_CAST( \
        (obj), flutter_i2c_plugin_get_type(), FlutterI2cPlugin))

struct _FlutterI2cPlugin {
    GObject parent_instance;
};

G_DEFINE_TYPE(FlutterI2cPlugin, flutter_i2c_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void flutter_i2c_plugin_handle_method_call(FlutterI2cPlugin *self,
                                                  FlMethodCall *method_call) {
    const gchar *method = fl_method_call_get_name(method_call);
    FlValue *    args   = fl_method_call_get_args(method_call);

    g_autoptr(FlMethodResponse) response = nullptr;

    if(strcmp(method, "getPlatformVersion") == 0) {
        struct utsname uname_data = {};
        uname(&uname_data);
        g_autofree gchar *version
            = g_strdup_printf("Linux %s", uname_data.version);
        g_autoptr(FlValue) result = fl_value_new_string(version);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    } else if(strcmp(method, kInitMethod) == 0) {
        response = flutter_i2c::init(args);
    } else if(strcmp(method, kDisposeMethod) == 0) {
        response = flutter_i2c::dispose(args);
    } else {
        response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    }

    g_autoptr(GError) error = nullptr;
    if(! fl_method_call_respond(method_call, response, &error)) {
        g_warning("Failed to send method call response: %s", error->message);
    }
}

static void flutter_i2c_plugin_dispose(GObject *object) {
    G_OBJECT_CLASS(flutter_i2c_plugin_parent_class)->dispose(object);
}

static void flutter_i2c_plugin_class_init(FlutterI2cPluginClass *klass) {
    G_OBJECT_CLASS(klass)->dispose = flutter_i2c_plugin_dispose;
}

static void flutter_i2c_plugin_init(FlutterI2cPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel,
                           FlMethodCall *   method_call,
                           gpointer         user_data) {
    FlutterI2cPlugin *plugin = FLUTTER_I2C_PLUGIN(user_data);
    flutter_i2c_plugin_handle_method_call(plugin, method_call);
}

void flutter_i2c_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
    FlutterI2cPlugin *plugin = FLUTTER_I2C_PLUGIN(
        g_object_new(flutter_i2c_plugin_get_type(), nullptr));

    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    g_autoptr(FlMethodChannel) channel
        = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                                kChannelName,
                                FL_METHOD_CODEC(codec));
    fl_method_channel_set_method_call_handler(
        channel, method_call_cb, g_object_ref(plugin), g_object_unref);

    g_object_unref(plugin);
}
