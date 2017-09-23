//
//  HttpHeadDataBuffer.swift
//  codegenv
//
//  Created by Bernardo Breder on 06/11/16.
//  Copyright © 2016 Code Generator Environment. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
    import DataBuffer
#endif

open class HttpHeadDataBuffer: DataBuffer {
    
    public override init() {
    }
    
    public func write100Continue() {
        write(string: "HTTP/1.1 100 Continue")
        writeEon()
    }
    
    public func write101Continue() {
        write(string: "HTTP/1.1 101 Switching Protocols")
        writeEon()
    }
    
    public func write103Continue() {
        write(string: "HTTP/1.1 103 Checkpoint")
        writeEon()
    }
    
    public func write200Ok() {
        write(string: "HTTP/1.1 200 OK")
        writeEon()
    }
    
    public func write201Created() {
        write(string: "HTTP/1.1 201 Created")
        writeEon()
    }
    
    public func write202Accepted() {
        write(string: "HTTP/1.1 202 Accepted")
        writeEon()
    }
    
    public func write203NonAuthoritativeInformation() {
        write(string: "HTTP/1.1 203 Non-Authoritative Information")
        writeEon()
    }
    
    public func write204NoContent() {
        write(string: "HTTP/1.1 204 No Content")
        writeEon()
    }
    
    public func write205ResetContent() {
        write(string: "HTTP/1.1 205 Reset Content")
        writeEon()
    }
    
    public func write206PartialContent() {
        write(string: "HTTP/1.1 206 Partial Content")
        writeEon()
    }
    
    public func write400BadRequest() {
        write(string: "HTTP/1.1 400 Bad Request")
        writeEon()
    }
    
    public func write300MultipleChoices() {
        write(string: "HTTP/1.1 300 Multiple Choices")
        writeEon()
    }
    
    public func write301MovedPermanently(url: String) {
        write(string: "HTTP/1.1 301 Moved Permanently")
        writeEon()
        write(string: "Location: \(url)")
        writeEon()
    }
    
    public func write401Unauthorized() {
        write(string: "HTTP/1.1 401 Access Denied")
        writeEon()
        write(string: "WWW-Authenticate: Basic realm=\"Code Generator Environment Server\"")
        writeEon()
    }
    
    public func write402PaymentRequired() {
        write(string: "HTTP/1.1 402 Payment Required")
        writeEon()
    }
    
    public func write403Forbidden() {
        write(string: "HTTP/1.1 403 Forbidden")
        writeEon()
    }
    
    public func write404NotFound() {
        write(string: "HTTP/1.1 404 Not Found")
        writeEon()
    }
    
    public func writeContentLength(length: Int) {
        write(string: "Content-Length: ")
        write(string: length.description);
        writeEon()
    }
    
    public func writeContentType(type: String) {
        write(string: "Content-Type: ")
        write(string: type);
        writeEon()
    }
    
    public func writeContentTypeJson() {
        writeContentType(type: "application/json")
    }
    
    public func writeContentTypeHtml() {
        writeContentType(type: "text/html")
    }
    
    public func writeEon() {
        write(string: "\r\n")
    }
    
}
