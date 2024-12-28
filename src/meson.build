sources += [
    'aikakim.vala',
    'dbus.vala',
    'window.vala',
    'ensure-types.vala',
]
deps = [
    dependency('gtk4'),
    dependency('gtk4-layer-shell-0'),
    dependency('gio-2.0'),
    dependency('gtk4-wayland'),
    meson.get_compiler('vala').find_library('wayland-client'),
]
executable(
    'aikakim',
    sources,
    dependencies: deps,
    link_args: ['-lm'],
    install: true,
)