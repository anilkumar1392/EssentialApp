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
        XCTAssertTrue(topController is FeedViewController, "Expected a feed ViewController as top view controller, Got \(String(describing: topController)) instead")
    }
}
