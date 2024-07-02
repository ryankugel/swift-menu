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

    public class IconButton : Gtk.Button {

        private Gtk.Image icon;

        construct {
            var style_context = get_style_context ();
            style_context.add_class ("flat");
            style_context.remove_class ("button");

            icon = new Gtk.Image ();
            set_image (icon);
        }

        /**
         * Set the button's icon by icon name.
         */
        public void set_icon (string icon_name, int pixel_size) {
            icon.set_from_icon_name (icon_name, Gtk.IconSize.INVALID);
            set_pixel_size (pixel_size);
        }

        /**
         * Sets the button's icon by a scaled pixbuf.
         */
        public void set_pixbuf (Gdk.Pixbuf pixbuf, int pixel_size) {
            var scaled_pixbuf = pixbuf.scale_simple (pixel_size, pixel_size, Gdk.InterpType.BILINEAR);
            icon.set_from_pixbuf (scaled_pixbuf);
        }

        /**
         * Updates the icon's size.
         */
        public void set_pixel_size (int pixel_size) {
            icon.pixel_size = pixel_size;
        }

        /**
         * Updates the icon's visibility.
         * This is generally only used when the icon setting is set to an invalid file/path.
         */
        public void update_visibility (bool visible) {
            icon.set_visible (visible);
        }

    }

}