install_data(
    'SwiftMenu.plugin',
    install_dir: appletdir
)

swift_menu_sources = [
    'Constants.vala',
    'SwiftMenu.vala',
    'Services/LockInterface.vala',
    'Services/LoginInterface.vala',
    'Services/SessionInterface.vala',
    'Services/UserInterface.vala',
    'Widgets/IconButton.vala',
    'Widgets/IconPicker.vala',
    'Widgets/MenuSettings.vala',
    'Widgets/Popover.vala'
]

swift_menu_dependencies = [
    gtk_dep,
    glib_dep,
    budgie_dep,
    accountsservice_dep
]

shared_library(
    'swiftmenu',
    swift_menu_sources,
    dependencies: swift_menu_dependencies,
    install: true,
    install_dir: appletdir
)