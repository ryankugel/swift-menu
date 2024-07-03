project(
    'com.github.ryankugel.swift-menu',
    'vala', 'c',
    version: '1.0.0',
    meson_version: '>=0.40'
)

# Dependencies
gtk_dep = dependency('gtk+-3.0')
glib_dep = dependency('glib-2.0')
budgie_dep = dependency('budgie-1.0')
accountsservice_dep = dependency('accountsservice')

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
datadir = join_paths(prefix, get_option('datadir'))
appletdir = join_paths(prefix, libdir, 'budgie-desktop', 'plugins', meson.project_name())
message('RYAN prefix: ' + prefix)
message('RYAN libdir: ' + libdir)
message('RYAN datadir: ' + datadir)
message('RYAN appletdir: ' + appletdir)

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

subdir('src')
subdir('data')

meson.add_install_script('meson/post_install.py')
