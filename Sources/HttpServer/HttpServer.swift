//
//  HttpServer.swift
//  codgenv
//
//  Created by Bernardo Breder on 02/11/16.
//  Copyright © 2016 Code Generator Environment. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
    import Server
    import StdServer
    import Log
#endif

open class HttpServer {
    
    private var services: [String:(HttpRequest) throws -> HttpResponse] = [:]
    
    public weak var log: Log?
    
    public init() {
    }
        
    open func handler(server: Server, client: Client) throws {
        log?.info("[HttpServer]: Reading Header Http Client")
        let request = try HttpRequest(client: client, log: log)
        log?.info("[HttpServer]: Header Http Client readed for path: \(request.path)")
        if let callback = self.services[request.path] {
            log?.info("[HttpServer]: Processing response")
            let response = try callback(request)
            let data = response.data()
            log?.info("[HttpServer]: Processed response with content length: \(data.count)")
            try client.write(data: data)
            log?.info("[HttpServer]: Writed response")
        } else {
            log?.info("[HttpServer]: Response page not found")
            let response = HttpResponse()
            response.body.write(string: "Page Not Found: ")
            response.body.write(string: request.path)
            response.head.write404NotFound()
            response.head.writeContentLength(length: response.body.size)
            response.head.writeEon()
            try client.write(data: response.data())
        }
        if !request.header.keepAlive {
            log?.info("[HttpServer]: Closed Http Client")
            client.close()
        }
    }
    
    public func resource(query: String, path: String) {
        self.services[query] = { (request: HttpRequest) -> HttpResponse in
            let response = HttpResponse()
            response.body.write(string: "Page Not Found: ")
            response.body.write(string: request.path)
            response.head.write404NotFound()
            response.head.writeContentLength(length: response.body.size)
            response.head.writeEon()
            return response
        }
    }
    
    public func service(query: String, callback: @escaping (HttpRequest) throws -> HttpResponse) {
        self.services[query] = callback
    }
    
}
