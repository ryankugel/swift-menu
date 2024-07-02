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

    public class IconPicker : Gtk.FileChooserDialog {

        public IconPicker (Gtk.Window parent) {
            Object (
                transient_for: parent,
                use_header_bar: 1,
                title: "Choose Menu Icon",
                action: Gtk.FileChooserAction.OPEN,
                modal: true,
                select_multiple: false,
                show_hidden: false,
                local_only: true
            );

            // Only allow files usable with a gdk-pixbuf
            Gtk.FileFilter filter = new Gtk.FileFilter ();
            filter.add_pixbuf_formats ();
            filter.set_name ("Image Files");
            add_filter (filter);

            // Prefer the user's XDG pictures directory by default
            var pictures_directory = Environment.get_user_special_dir (UserDirectory.PICTURES);
            if (pictures_directory != null) {
                set_current_folder (pictures_directory);
            }

            add_button ("Cancel", Gtk.ResponseType.CANCEL);
            var select_button = add_button ("Select Icon", Gtk.ResponseType.ACCEPT);
            select_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        }

        public new string? run () {
            base.show_all ();
            int response = base.run ();

            if (response == Gtk.ResponseType.ACCEPT) {
                return get_filename ();
            }

            return null;
        }

    }

}