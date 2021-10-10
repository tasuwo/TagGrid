// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TagGrid",
    products: [
        .library(
            name: "TagGrid",
            targets: ["TagGrid"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TagGrid",
            dependencies: []
        ),
        .testTarget(
            name: "TagGridTests",
            dependencies: ["TagGrid"]
        ),
    ]
)
