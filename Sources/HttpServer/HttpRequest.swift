//
//  HttpRequest.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import Server
    import Log
#endif

public enum HttpRequestError: Error {
    case requestTooBig
    case requestNotHttpProtocol
    case headerNotString
    case headerNoLines
    case methodUnknown
    case noDataFound
    case invalidParameters
    case utf8
}

open class HttpRequest {
    
    public let client: Client
    
    public let method: HttpMethod
    
    public let path: String
    
    public let header: HttpHeader
    
    public var length: Int
    
    public convenience init(client: Client, log: Log?) throws {
        func eof(data: Data) -> Bool {
            let dataCount = data.count
            if dataCount < 4 { return false }
            return data[dataCount-1] == 10 && data[dataCount-2] == 13 && data[dataCount-3] == 10 && data[dataCount-4] == 13
        }
        log?.info("[HttpRequest]: Creating buffer")
        var data: Data = Data(capacity: 1024)
        while !eof(data: data) {
            if (data.count % 128) == 0 {
                log?.info("[HttpRequest]: Readed \(data.count) bytes")
            }
            data.append(try client.read())
            guard data.count <= 4 * 1024 else {
                log?.info("[HttpRequest]: Request too big")
                throw HttpRequestError.requestTooBig
            }
        }
        log?.info("[HttpRequest]: Readed \(data.count) bytes")
        log?.info("[HttpRequest]: Finished: \(eof(data: data))")
        guard eof(data: data) else { throw HttpRequestError.requestNotHttpProtocol }
        try self.init(client: client, data: data, log: log)
    }
    
    public convenience init(client: Client, data: Data, log: Log?) throws {
        guard let content: String = String(data: data, encoding: .utf8) else { throw HttpRequestError.headerNotString }
        log?.info("[HttpRequest]: Content: \n\(content)")
        let lines = content.characters.split(separator: "\r\n").map(String.init)
        log?.info("[HttpRequest]: Split \(lines.count) lines")
        guard lines.count > 0 else { throw HttpRequestError.headerNoLines }
        let firsts = lines[0].characters.split(separator: " ").map(String.init)
        log?.info("[HttpRequest]: First line: \(firsts)")
        guard let method: HttpMethod = HttpMethod.value(string: firsts[0]) else { throw HttpRequestError.methodUnknown }
        log?.info("[HttpRequest]: Method: \(method)")
        let path = firsts[1]
        log?.info("[HttpRequest]: Path: \(path)")
        let header: HttpHeader = HttpHeader(lines: lines)
        log?.info("[HttpRequest]: Header: \(header)")
        self.init(client: client, method: method, path: path, header: header)
    }
    
    public init(client: Client, method: HttpMethod, path: String, header: HttpHeader) {
        self.client = client
        self.method = method
        self.path = path
        self.header = header
        self.length = header.intValue(name: "content-length") ?? 0
    }
    
    public func readContent(bytes: inout [UInt8]) throws -> Int {
        guard length > 0 else { return 0 }
        let count = bytes.count
        for i in 0 ..< count {
            guard length > 0 else { return i }
            bytes[i] = try client.read()
            length = length - 1
        }
        return count
    }
    
    public func readAllContent(maxLength: Int = 16 * 1024 * 1024) throws -> Data {
        guard length > 0 else { throw HttpRequestError.noDataFound }
        guard length <= maxLength else { throw HttpRequestError.requestTooBig }
        var data: Data = Data(capacity: length)
        for _ in 0 ..< length {
            data.append(try client.read())
        }
        return data
    }
    
    public var keepAlive: Bool {
        guard let connectionHeader = header["connection"] else { return false }
        return connectionHeader != "close"
    }
    
    public var contentLength: Int {
        return length
    }
    
}
