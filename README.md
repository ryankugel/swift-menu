# Swift Menu

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
Swift Menu supports Debian packaging for distros such as Ubuntu. The following steps will allow you to generate a new `.deb` package for swift-menu.

### Install debhelper
`debhelper` is used to configure our build environment and generate the Debian package.

The dependencies of `swift-menu` listed above all need to be installed, along with `meson` and `debhelper` in order to generate new packages.

It's a good idea to try building `swift-menu` outside of `dpkg-buildpackage` using the steps above to confirm you have all the necessary dependencies.

### Generate the Debian package
`dpkg-buildpackage -rfakeroot -us -uc -b`
- The `debian/rules` file includes a custom command for configuring the build environment. This is required in order to set a custom `--libdir` during the `meson setup` step.