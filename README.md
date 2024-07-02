# swift-menu

## A simplified root menu for Budgie mimicking macOS.

A very basic menu that contains similar options to macOS root panel menu. Using this assumes you'd use another way of launching applications, like using swift-launch.

## Installing from source
Required dependencies:
* `gtk+-3.0`
* `glib-2.0`
* `budgie-1.0`
* `accountsservice`

Run `meson` to configure the build environment and then use `ninja` to build and install

    meson build --prefix=/usr --libdir=/usr/lib
    cd build
    ninja
    sudo ninja install

## Packaging
swift-menu supports Debian packaging for distros such as Ubuntu. The following steps will allow you to generate a new `.deb` package for swift-menu.

### Configure the build
`dh_auto_configure --buildsystem=meson`

### Generate the Debian package
`dpkg-buildpackage -rfakeroot -us -uc -b`