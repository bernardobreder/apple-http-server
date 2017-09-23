//
//  HttpServer+Data.swift
//  codegenv
//
//  Created by Bernardo Breder on 16/11/16.
//
//

import Foundation

extension Data {
    
    public func httpHeader() -> (first: [String], header: HttpHeader)? {
        guard let headerString: String = String(data: self, encoding: .utf8) else { return nil }
        let lines = headerString.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        guard lines.count > 1 else { return nil }
        let first = lines[0].characters.split { $0 == " " }.map(String.init)
        var header: [String: String] = [String: String]()
        for line in lines.suffix(from: 1) {
            if let indexOf: String.Index = line.characters.index(of: ":") {
                let key = String(line.characters.prefix(through: line.index(before: indexOf))).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()
                let value = String(line.substring(from: line.index(after: indexOf))).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                header[key] = value
            }
        }
        return (first, HttpHeader(headers: header))
    }
    
    public func httpHeadBody() -> (first: [String], header: HttpHeader, body: Data)? {
        guard let range: Range = self.range(of: Data([13, 10, 13, 10])) else { return nil }
        guard let head: (first: [String], header: HttpHeader) = subdata(in: 0 ..< range.lowerBound).httpHeader() else { return nil }
        let body: Data
        if let length: Int = head.header.intValue(name: "content-length") {
            body = self.subdata(in: range.upperBound ..< self.index(length, offsetBy: range.upperBound))
        } else {
            body = Data()
        }
        return (head.first, head.header, body)
    }
    
}
