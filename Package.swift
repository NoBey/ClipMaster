// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "ClipMaster",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ClipMaster",
            targets: ["ClipMaster"]
        )
    ],
    dependencies: [
        // 如果需要使用 CoreData，可以添加依赖
    ],
    targets: [
        .systemLibrary(
            name: "CSQLite"
        ),
        .executableTarget(
            name: "ClipMaster",
            dependencies: ["CSQLite"],
            path: "ClipMaster",
            exclude: ["Resources"], // 资源文件需要单独处理
            sources: [
                "ClipMasterApp.swift",
                "AppDelegate.swift",
                "Models",
                "Views",
                "ViewModels",
                "Services",
                "Managers",
                "Utilities",
                "Database"
            ],
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SwiftUI"),
                .linkedLibrary("sqlite3")
            ]
        )
    ]
)
