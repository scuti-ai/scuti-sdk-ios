// swift-tools-version:5.3
import PackageDescription


let package = Package(
    name: "ScutiSDKSwift",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "ScutiSDKSwift",
            targets: ["ScutiSDKSwift"])
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ScutiSDKSwift",
            path: "ScutiSDKSwift",
//            exclude: ["instructions.md"],
            resources: [
                .process("Resources"),
//                .process("new_items_flag@2x.png"),
//                .process("scuti_logo_white@2x.png"),
            ]
        ),
    ]
)
