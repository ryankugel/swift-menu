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

namespace SwiftMenu.Constants {

    public const string SETTINGS_SCHEMA_ID = "com.github.ryankugel.swift-menu";
    public const string MENU_ICON_SETTINGS_KEY = "menu-icon";

    // DBus services
    public const string LOCK_INTERFACE_DBUS = "org.gnome.ScreenSaver";
    public const string LOCK_INTERFACE_DBUS_PATH = "/org/gnome/ScreenSaver";

    public const string SESSION_MANAGER_DBUS = "org.gnome.SessionManager";
    public const string SESSION_MANAGER_DBUS_PATH = "/org/gnome/SessionManager";

    public const string LOGIN_INTERFACE_DBUS = "org.freedesktop.login1";
    public const string LOGIN_INTERFACE_DBUS_PATH = "/org/freedesktop/login1";

    // Applications
    public const string CONTROL_CENTER = "budgie-control-center";
    public const string CONTROL_CENTER_NAME = "Budgie Control Center";
    public const string CONTROL_CENTER_DESKTOP_FILE = "budgie-control-center.desktop";

    public const string ABOUT_COMPUTER_NAME = "About Computer";
    public const string ABOUT_COMPUTER_DESKTOP_FILE = "budgie-info-overview-panel.desktop";

    public const string APP_CENTER = "snap-store";
    public const string APP_CENTER_NAME = "App Center";
    public const string APP_CENTER_DEKSTOP_FILE = "snap-store_snap-store.desktop";

    // Account management
    public const uint GUEST_USER_UID = 999;
    public const uint NOBODY_USER_UID = 65534;
    public const uint RESERVED_UID_RANGE_END = 1000;
    public const string ACTIVE_USER = "active";

}