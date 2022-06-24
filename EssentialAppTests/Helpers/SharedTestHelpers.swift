//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by 13401027 on 24/06/22.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
