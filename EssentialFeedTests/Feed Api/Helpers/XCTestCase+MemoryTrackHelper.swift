//
//  XCTestCase+MemoryTrackHelper.swift
//  EssentialFeedTests
//
//  Created by Omar Noppe on 08/08/2022.
//

import XCTest

extension XCTestCase {

    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
