sources += [
    'aikakim.vala',
    'dbus.vala',
]

deps = [
    dependency('gtk4'),
    dependency('gtk4-layer-shell-0'),
    dependency('gio-2.0'),
]
executable(
    'aikadm',
    sources,
    dependencies: deps,
    link_args: ['-lm'],
    install: true,
)