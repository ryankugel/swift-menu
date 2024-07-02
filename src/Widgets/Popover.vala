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
     * The popover that's displayed when the applet is clicked
     */
     public class Popover : Budgie.Popover {

        public IconButton icon_button { private get; construct; }

        public Gtk.Box main_layout { private get; construct; }

        public Act.UserManager user_manager { private get; construct; }

        private Gtk.ModelButton log_out_menu_item;

        private LockInterface lock_interface;
        private LoginInterface login_interface;
        private SessionInterface session_interface;

        public Popover (IconButton parent) {
            Object (
                relative_to: parent,
                icon_button: parent,
                main_layout: new Gtk.Box (Gtk.Orientation.VERTICAL, 0),
                user_manager: Act.UserManager.get_default ()
            );
        }

        construct {
            var about_menu_item = new Gtk.ModelButton () {
                text = "About This Computer"
            };
            about_menu_item.clicked.connect (on_about_clicked);

            var settings_menu_item = new Gtk.ModelButton () {
                text = "System Settings..."
            };
            settings_menu_item.clicked.connect (on_settings_clicked);

            var app_center_menu_item = new Gtk.ModelButton () {
                text = "App Center"
            };
            app_center_menu_item.clicked.connect (on_app_center_clicked);

            var sleep_menu_item = new Gtk.ModelButton () {
                text = "Sleep",
                no_show_all = true
            };
            sleep_menu_item.clicked.connect (on_sleep_clicked);

            var restart_menu_item = new Gtk.ModelButton () {
                text = "Restart..."
            };
            restart_menu_item.clicked.connect (on_restart_clicked);

            var shutdown_menu_item = new Gtk.ModelButton () {
                text = "Shut Down..."
            };
            shutdown_menu_item.clicked.connect (on_shut_down_clicked);

            var lock_screen_menu_item = new Gtk.ModelButton () {
                text = "Lock Screen"
            };
            lock_screen_menu_item.clicked.connect (on_lock_screen_clicked);

            log_out_menu_item = new Gtk.ModelButton () {
                text = "Log Out..."
            };
            log_out_menu_item.clicked.connect (on_log_out_clicked);

            initialize_interfaces.begin ((obj, res) => {
                try {
                    // Show the "Sleep" button if the system can suspend
                    if (login_interface.can_suspend () == "yes") {
                        sleep_menu_item.show ();
                    }
                } catch (Error e) {
                    warning ("Failed to get information about suspend availability: %s", e.message);
                }

                // Update the "Log Out" button with the current user's name
                update_active_user.begin ();

                initialize_interfaces.end (res);
            });

            main_layout.pack_start (about_menu_item, true, true, 0);
            main_layout.pack_start (get_menu_separator (), true, true, 0);
            main_layout.pack_start (settings_menu_item, true, true, 0);
            main_layout.pack_start (app_center_menu_item, true, true, 0);
            main_layout.pack_start (get_menu_separator (), true, true, 0);
            main_layout.pack_start (sleep_menu_item, true, true, 0);
            main_layout.pack_start (restart_menu_item, true, true, 0);
            main_layout.pack_start (shutdown_menu_item, true, true, 0);
            main_layout.pack_start (get_menu_separator (), true, true, 0);
            main_layout.pack_start (lock_screen_menu_item, true, true, 0);
            main_layout.pack_start (log_out_menu_item, true, true, 0);
            main_layout.show_all ();

            add (main_layout);
        }

        /**
         * Fetches the DBus services needed to perform many of the menu item actions.
         */
        private async void initialize_interfaces () {
            try {
                lock_interface = yield Bus.get_proxy (
                    BusType.SESSION,
                    Constants.LOCK_INTERFACE_DBUS,
                    Constants.LOCK_INTERFACE_DBUS_PATH
                );
            } catch (IOError e) {
                warning ("Unable to connect to lock interface: %s", e.message);
            }

            try {
                login_interface = yield Bus.get_proxy (
                    BusType.SYSTEM,
                    Constants.LOGIN_INTERFACE_DBUS,
                    Constants.LOGIN_INTERFACE_DBUS_PATH
                );
            } catch (IOError e) {
                warning ("Unable to connect to login interface: %s", e.message);
            }

            try {
                session_interface = yield Bus.get_proxy (
                    BusType.SESSION,
                    Constants.SESSION_MANAGER_DBUS,
                    Constants.SESSION_MANAGER_DBUS_PATH
                );
            } catch (IOError e) {
                warning ("Unable to connect to session interface: %s", e.message);
            }
        }

        /**
         * Determines the current user's name and updates the "Log Out" button for that name.
         */
        private async void update_active_user () {
            foreach (var user in user_manager.list_users ()) {
                if (user.uid < Constants.RESERVED_UID_RANGE_END || user.uid == Constants.NOBODY_USER_UID) {
                    continue;
                }

                var user_active = yield is_user_active (user.uid);

                if (user_active) {
                    var user_name = user.real_name;
                    if (user_name == null || user_name == "") {
                        user_name = user.user_name;
                    }

                    log_out_menu_item.text = "Log Out %s...".printf (user_name);
                }

            }
        }

        /**
         * Determines if the user for a given ID is actively logged in.
         */
        private async bool is_user_active (uint32 uid) {
            try {
                var users = login_interface.list_users ();

                foreach (UserInfo user in users) {
                    if (user.uid == uid) {
                        if (user.user_object == null) {
                            continue;
                        }
    
                        UserInterface user_interface = yield Bus.get_proxy (
                            BusType.SYSTEM,
                            Constants.LOGIN_INTERFACE_DBUS,
                            user.user_object,
                            DBusProxyFlags.NONE
                        );
    
                        if (user_interface.state == Constants.ACTIVE_USER) {
                            debug ("Actively logged in user: '%s'", user.user_name);
                            return true;
                        }
                    }
                }
            } catch (Error e) {
                message ("Unable to read user accounts: %s", e.message);
            }

            return false;
        }

        /**
         * Launches the "About" panel in Budgie Control Center.
         */
        private void on_about_clicked () {
            launch_application (
                Constants.ABOUT_COMPUTER_NAME, 
                Constants.CONTROL_CENTER, 
                Constants.ABOUT_COMPUTER_DESKTOP_FILE
            );

            hide ();
        }

        /**
         * Launches Budgie Control Center.
         */
        private void on_settings_clicked () {
            launch_application (
                Constants.CONTROL_CENTER_NAME,
                Constants.CONTROL_CENTER,
                Constants.CONTROL_CENTER_DESKTOP_FILE
            );

            hide ();
        }

        /**
         * Launches the Snap Store.
         */
        private void on_app_center_clicked () {
            launch_application (
                Constants.APP_CENTER_NAME,
                Constants.APP_CENTER,
                Constants.APP_CENTER_DEKSTOP_FILE
            );

            hide ();
        }

        /**
         * Action to take when the "Sleep" button is clicked.
         */
        private void on_sleep_clicked () {
            try {
                login_interface.suspend (true);
            } catch (Error e) {
                warning ("Unable to suspend: %s", e.message);
            }

            hide ();
        }

        /**
         * Action to take when the "Restart" button is clicked.
         *
         * This won't directly restart the computer, but rather will launch a confirmation
         * dialog asking the user if they want to restart.
         */
        private void on_restart_clicked () {
            session_interface.reboot.begin ((obj, res) => {
                try {
                    session_interface.reboot.end (res);
                } catch (Error e) {
                    if (!(e is GLib.IOError.CANCELLED)) {
                        warning ("Unable to reboot: %s", e.message);
                    }
                }
            });

            hide ();
        }

        /**
         * Action to take when the "Shut Down" button is clicked.
         *
         * This won't directly shut down the computer, but rather will launch a confirmation
         * dialog asking the user if they want to shut down.
         */
        private void on_shut_down_clicked () {
            session_interface.shutdown.begin ((obj, res) => {
                try {
                    session_interface.shutdown.end (res);
                } catch (Error e) {
                    if (!(e is GLib.IOError.CANCELLED)) {
                        warning ("Unable to shutdown: %s", e.message);
                    }
                }
            });

            hide ();
        }

        /**
         * Action to take when the "Lock Screen" button is clicked.
         */
        private void on_lock_screen_clicked () {
            lock_interface.lock.begin ((obj, res) => {
                try {
                    lock_interface.lock.end (res);
                } catch (Error e) {
                    warning ("Unable to lock screen: %s", e.message);
                }
            });

            hide ();
        }

        /**
         * Action to take when the "Log Out" button is clicked.
         */
        private void on_log_out_clicked () {
            session_interface.logout.begin (0, (obj, res) => {
                try {
                    session_interface.logout.end (res);
                } catch (Error e) {
                    warning ("Unable to log out: %s", e.message);
                }
            });

            hide ();
        }

        /**
         * Creates a {@link Gtk.Separator} for separating elements in the popover. 
         */
        private Gtk.Separator get_menu_separator () {
            return new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
                margin_top = 3,
                margin_bottom = 3,
                width_request = 210
            };
        }

        /**
         * Launches an application by finding its {@link DesktopAppInfo}.
         */
        private void launch_application (string app_name, string executable_name, string desktop_file) {
            if (Environment.find_program_in_path (executable_name) == null) {
                warning ("Unable to find executable '%s' for application '%s'", executable_name, app_name);
                return;
            }

            var app_info = new DesktopAppInfo (desktop_file);

            if (app_info == null) {
                warning ("Unable to load desktop file '%s' for application '%s'", desktop_file, app_name);
                return;
            }

            try {
                app_info.launch (null, null);
            } catch (Error e) {
                warning ("Unable to launch '%s': %s", app_name, e.message);
            }
        }

    }

}