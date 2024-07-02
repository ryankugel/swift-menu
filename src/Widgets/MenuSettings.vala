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
     * The UI that's displayed for the applet in Budgie Desktop Settings.
     */
    public class MenuSettings : Gtk.Grid {

        private Gtk.Entry icon_text_field;

        public MenuSettings (GLib.Settings settings) {
            settings.bind (Constants.MENU_ICON_SETTINGS_KEY, icon_text_field, "text", SettingsBindFlags.DEFAULT);
        }

        construct {
            var icon_settings = build_icon_settings ();
            attach (icon_settings, 0, 0);

            show_all ();
        }

        /**
         * Builds the widget containing menu icon settings.
         */
        private Gtk.Box build_icon_settings () {
            var icon_settings = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true
            };

            // Create the text field and button for selecting a menu icon
            icon_text_field = new Gtk.Entry ();

            var choose_icon_button = new Gtk.Button.from_icon_name ("folder_open", Gtk.IconSize.MENU);
            choose_icon_button.clicked.connect (on_choose_icon_click);

            // Create a linked grid to contain the text field and button
            var icon_entry_grid = new Gtk.Grid ();
            icon_entry_grid.get_style_context ().add_class ("linked");
            
            icon_entry_grid.attach (icon_text_field, 0, 0);
            icon_entry_grid.attach (choose_icon_button, 1, 0);

            // Create a label for the setting
            var setting_label = new Gtk.Label ("Menu Icon");

            icon_settings.pack_start (setting_label, false, false, 0);
            icon_settings.pack_end (icon_entry_grid, false, false, 0);
            return icon_settings;
        }

        private void on_choose_icon_click () {
            var icon_picker = new IconPicker (get_toplevel () as Gtk.Window);

            var response = icon_picker.run ();
            icon_picker.destroy ();

            if (response != null) {
                icon_text_field.set_text (response);
            }
        }

    }

}