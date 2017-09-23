//
//  Package.swift
//  HttpServer
//
//

import PackageDescription

let package = Package(
	name: "HttpServer",
	targets: [
		Target(name: "HttpServer", dependencies: ["Log", "StdServer"]),
		Target(name: "AtomicValue", dependencies: []),
		Target(name: "DataBuffer", dependencies: []),
		Target(name: "DataStream", dependencies: []),
		Target(name: "Date", dependencies: []),
		Target(name: "FileSystem", dependencies: []),
		Target(name: "Log", dependencies: ["AtomicValue", "Date", "FileSystem", "Optional"]),
		Target(name: "Optional", dependencies: []),
		Target(name: "Server", dependencies: []),
		Target(name: "StdServer", dependencies: ["DataBuffer", "DataStream", "Server", "StdSocket"]),
		Target(name: "StdSocket", dependencies: []),
	]
)

