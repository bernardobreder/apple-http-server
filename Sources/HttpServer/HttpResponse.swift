//
//  HttpResponse.swift
//  codegenv
//
//  Created by Bernardo Breder on 12/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import DataBuffer
#endif

public enum HttpResponseError: Error {
    case writeResponse
}

open class HttpResponse {
    
    public let head = HttpHeadDataBuffer()
    
    public let body = DataBuffer()
    
    public init() {
    }
    
    public func data() -> Data {
        var data = Data()
        data.append(head.data())
        data.append(body.data())
        return data
    }
    
}
