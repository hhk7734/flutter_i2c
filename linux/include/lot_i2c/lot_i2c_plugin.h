#ifndef FLUTTER_PLUGIN_LOT_I2C_PLUGIN_H_
#define FLUTTER_PLUGIN_LOT_I2C_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _LotI2cPlugin LotI2cPlugin;
typedef struct {
    GObjectClass parent_class;
} LotI2cPluginClass;

FLUTTER_PLUGIN_EXPORT GType lot_i2c_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void
    lot_i2c_plugin_register_with_registrar(FlPluginRegistrar *registrar);

G_END_DECLS

#endif    // FLUTTER_PLUGIN_LOT_I2C_PLUGIN_H_
