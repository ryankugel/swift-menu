/*
 * Copyright (C) 2024 Ryan Kugel
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace SwiftMenu {

    /**
     * Base Plugin for SwiftMenu.
     */
    public class Plugin : Budgie.Plugin, GLib.Object {

        public Budgie.Applet get_panel_widget (string uuid) {
            return new Applet (uuid);
        }

    }

    public class Applet : Budgie.Applet {

        public string uuid { get; set; }
        
        private GLib.Settings applet_settings;

        private Gtk.EventBox event_box;
        private IconButton icon_button;
        private Popover popover;

        private int pixel_size = 26;
        
        private unowned Budgie.PopoverManager? manager;

        public Applet (string uuid) {
            Object (
                uuid: uuid,
                width_request: 60
            );

            applet_settings = new GLib.Settings (Constants.SETTINGS_SCHEMA_ID);
            applet_settings.changed.connect (on_settings_changed);
            panel_size_changed.connect (on_panel_size_changed);

            // Create the button that's displayed on the panel
            icon_button = new IconButton ();
            on_settings_changed (Constants.MENU_ICON_SETTINGS_KEY);

            event_box = new Gtk.EventBox ();
            event_box.add (icon_button);
            add (event_box);

            // Create the popover that's displayed when the button is clicked
            popover = new Popover (icon_button);

            show_all ();
            connect_signals ();
        }

        public override void update_popovers (Budgie.PopoverManager? manager) {
            manager.register_popover (icon_button, popover);
            this.manager = manager;
        }

        public override bool supports_settings () {
            return true;
        }

        public override Gtk.Widget? get_settings_ui () {
            return new MenuSettings (applet_settings);
        }

        /**
         * Connect actions like clicking on the menu to open the popover.
         */
        private void connect_signals () {
            icon_button.clicked.connect (() => {
                if (popover.is_visible ()) {
                    popover.hide ();
                }
                else {
                    manager.show_popover (icon_button);
                }
            });
        }

        /**
         * React to settings updates.
         */
        private void on_settings_changed (string key) {
            var should_show = true;

            switch (key) {
                case Constants.MENU_ICON_SETTINGS_KEY:
                    var icon = applet_settings.get_string (key);

                    if ("/" in icon) {
                        try {
                            Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file (icon);
                            icon_button.set_pixbuf (pixbuf, pixel_size);
                        } catch (Error e) {
                            warning ("Unable to update SwiftMenu applet icon: %s", e.message);
                        }
                    }
                    else if (icon == "") {
                        should_show = false;
                    }
                    else {
                        icon_button.set_icon (icon, pixel_size);
                    }

                    icon_button.set_pixel_size (pixel_size);
                    icon_button.update_visibility (should_show);
                    break;
                default:
                    break;
            }
        }

        /**
         * React to the Budgie panel changing sizes.
         */
        private void on_panel_size_changed (int panel_size, int icon_size, int small_icon_size) {
            pixel_size = icon_size;
            on_settings_changed (Constants.MENU_ICON_SETTINGS_KEY);
        }

    }

}

[ModuleInit]
public void peas_register_types (TypeModule module) {
    Peas.ObjectModule object_module = module as Peas.ObjectModule;
    object_module.register_extension_type (typeof (Budgie.Plugin), typeof (SwiftMenu.Plugin));
}