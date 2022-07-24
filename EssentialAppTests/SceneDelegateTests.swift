//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by 13401027 on 26/06/22.
//

import Foundation
import XCTest
@testable import EssentialApp
import EssentialFeediOS

// Use testable because we don't want any other module to use SceneDelegate.
// MARK: - Validating Acceptance Criteria with Fast Integration Tests, Composition Root, and Simulating App Launch & State Transitions
// Lecture 5

/*
 To make our test reliable control all the components that are not reliable.
 1. let store = InMemoryFeedStore()
 2. let httpClient = HTTPClinetStub()
 
 Thus we dont want to make any real HTTP requests.
 Do this to get deterministic result.
 */



class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertTrue(window.isKeyWindow, "Expected window to be the key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController

        XCTAssertNotNil(rootNavigation, "Expecetd a navigation controller as root, got \(String(describing: root)) instead.")
        XCTAssertTrue(topController is ListViewController, "Expected a feed ViewController as top view controller, Got \(String(describing: topController)) instead")
    }
}
