//
//  HttpHeader.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation

open class HttpHeader {
    
    private let dic: [String: String]
    
    public convenience init(lines: [String]) {
        var header: [String: String] = [String: String]()
        for line in lines.suffix(from: 1) {
            if let indexOf: String.Index = line.characters.index(of: ":") {
                let key = String(line.characters.prefix(through: line.index(before: indexOf))).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()
                let value = String(line.substring(from: line.index(after: indexOf))).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                header[key] = value
            }
        }
        self.init(headers: header)
    }
    
    public init(headers: [String: String]) {
        self.dic = headers
    }
    
    public subscript(name: String) -> String? {
        return dic[name]
    }
    
    public func intValue(name: String) -> Int? {
        guard let value = dic[name] else { return nil }
        return Int.init(value)
    }
    
    public func authorization() -> (username: String, password: String)? {
        //        guard let value: String = dic["authorization"] else { return nil }
        //        let base64 = value.substring(from: value.index(value.startIndex, offsetBy: "Basic ".characters.count)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //        guard let data = Data(base64Encoded: base64) else { return nil }
        //        let content = String(data: data, encoding: .utf8)
        //         let array = content.split("&")
        return nil
    }
    
    public var keepAlive: Bool {
        guard let value = dic["connection"] else { return false }
        return value != "close"
    }
    
}

public enum HttpMethod {
    
    case get, post
    
    public static func value(string: String) -> HttpMethod? {
        switch string.uppercased() {
        case "GET": return .get
        case "POST": return .post
        default: return nil
        }
    }
    
}
