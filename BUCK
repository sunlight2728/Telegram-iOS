load("//Config:configs.bzl", "app_binary_configs", "share_extension_configs", "library_configs", "pretty", "info_plist_substitutions", "app_info_plist_substitutions", "share_extension_info_plist_substitutions", "DEVELOPMENT_LANGUAGE")
load("//Config:buck_rule_macros.bzl", "apple_lib", "framework_binary_dependencies", "framework_bundle_dependencies")

static_library_dependencies = [
]

framework_dependencies = [
    "//submodules/MtProtoKit:MtProtoKit",
    "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
    "//submodules/Postbox:Postbox",
    "//submodules/TelegramCore:TelegramCore",
    "//submodules/AsyncDisplayKit:AsyncDisplayKit",
    "//submodules/Display:Display",
    "//submodules/TelegramUI:TelegramUI",
]

resource_dependencies = [
    "//submodules/LegacyComponents:LegacyComponentsResources",
    "//submodules/TelegramUI:TelegramUIAssets",
    "//submodules/TelegramUI:TelegramUIResources",
    "//:AppResources",
    "//:AppStringResources",
    "//:Icons",
    "//:AppIcons",
    "//:AdditionalIcons",
    "//:LaunchScreen",
]

build_phase_scripts = [
]

apple_resource(
    name = "AppResources",
    files = glob([
        "Telegram-iOS/Resources/**/*",
    ], exclude = ["Telegram-iOS/Resources/**/.*"]),
    visibility = ["PUBLIC"],
)

apple_resource(
    name = "AppStringResources",
    files = [],
    variants = glob([
        "Telegram-iOS/*.lproj/Localizable.strings",
    ]),
    visibility = ["PUBLIC"],
)

apple_asset_catalog(
  name = 'Icons',
  dirs = [
    "Telegram-iOS/Icons.xcassets",
  ],
  visibility = ["PUBLIC"],
)

apple_asset_catalog(
  name = 'AppIcons',
  dirs = [
    "Telegram-iOS/AppIcons.xcassets",
  ],
  visibility = ["PUBLIC"],
)

apple_resource(
    name = "AdditionalIcons",
    files = glob([
        "Telegram-iOS/*.png",
    ]),
    visibility = ["PUBLIC"],
)

apple_resource(
    name = 'LaunchScreen',
    files = [
        'Telegram-iOS/Base.lproj/LaunchScreen.xib',
    ],
    visibility = ["PUBLIC"],
)

apple_library(
    name = "AppLibrary",
    visibility = [
        "//:",
        "//...",
    ],
    configs = library_configs(),
    swift_version = native.read_config("swift", "version"),
    srcs = [
        "Telegram-iOS/main.m",
        "Telegram-iOS/Application.swift"
    ],
    deps = [
    ]
    + static_library_dependencies
    + framework_binary_dependencies(framework_dependencies),
)

apple_binary(
    name = "AppBinary",
    visibility = [
        "//:",
        "//...",
    ],
    configs = app_binary_configs("Telegram"),
    swift_version = native.read_config("swift", "version"),
    srcs = [
        "SupportFiles/Empty.swift",
    ],
    deps = [
        ":AppLibrary",
    ]
    + resource_dependencies,
)

xcode_workspace_config(
    name = "workspace",
    workspace_name = "Telegram_Buck",
    src_target = ":Telegram",
)

apple_bundle(
    name = "Telegram",
    visibility = [
        "//:",
    ],
    extension = "app",
    binary = ":AppBinary",
    product_name = "Telegram",
    info_plist = "Telegram-iOS/Info.plist",
    info_plist_substitutions = app_info_plist_substitutions("Telegram"),
    deps = [
        ":ShareExtension",
    ]
    + framework_bundle_dependencies(framework_dependencies),
)

apple_binary(
    name = "ShareBinary",
    srcs = glob([
        "Share/**/*.swift",
    ]),
    configs = share_extension_configs("Share"),
    linker_flags = [
        "-e",
        "_NSExtensionMain",
        "-Xlinker",
        "-rpath",
        "-Xlinker",
        "@executable_path/../../Frameworks",
    ],
    deps = [
        "//submodules/TelegramUI:TelegramUI#shared",
    ],
)

apple_bundle(
    name = "ShareExtension",
    binary = ":ShareBinary",
    extension = "appex",
    info_plist = "Share/Info.plist",
    info_plist_substitutions = share_extension_info_plist_substitutions("Share"),
    deps = [
    ],
    xcode_product_type = "com.apple.product-type.app-extension",
)

apple_package(
    name = "AppPackage",
    bundle = ":Telegram",
)
