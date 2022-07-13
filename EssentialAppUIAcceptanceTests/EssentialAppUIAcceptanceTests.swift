//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by 13401027 on 25/06/22.
//

import XCTest

// MARK: - Validating Acceptance Criteria with High-Level UI Tests, Controlling Network and App State in UI tests with Launch Arguments and Conditional Compilation Directives
// Lecture 4.

class EssentialAppUIAcceptanceTests: XCTestCase {
    
    // UI tests are state full means one test can have impact on anther test so its better to manage state while renning them.
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset", "-connectivity", "online"]
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 2)
        
        let feedImages = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(feedImages.exists)
    }
    
    func test_onLaunch_displayCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let onlineApp = XCUIApplication()
        onlineApp.launchArguments = ["-reset", "-connectivity", "online"]
        onlineApp.launch()
        
        let offlineApp = XCUIApplication()
        offlineApp.launchArguments = ["-connectivity", "offline"]
        offlineApp.launch()
        
        let feedCells = offlineApp.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 2)
        
        let feedImages = offlineApp.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(feedImages.exists)
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset","-connectivity", "offline"]
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 0)
    }
}


// MARK: - Here we are writing test for Composer.
/*
 Like load from remote.
 Save in local.
 Show from local.
 
 This way we are testing that our composition works.
 */

// MARK: - UI Tests or Black box Test.
// This is also called Black box testing because we do not have any internal detials of the application.
// you only access it from the outside as any customer would.
// -reset to clean it's state.
// -connectivity to ensure app network state.

// CommandLIne arguments is a different way to read launch arguments.
// if you want to read value you can simply use UserDefault to read them.

// MARK: - Higher level acceptance test.
// Testing the usecase from a higher level.

/*
 High level acceptance test Tests app by launching and running the app so these tests are very slow.
 While testing for UIAcceptacne test we should test very minimum because of their slow nature and we have also tested individual components in isolation.
 */

// MARK: - Test code in production

/*
 We do not want test code in production.
 We do not want to deploy test code to production.
 Because it can have security implications.
 as in this way a malicious user can launch or app with arguments and can control the state of our app.
 
 Minimum we can do is to add compilation directive.
 
 This is the Problem with UI test.
 if we need any kind of control to test some edge cases we need to inject code in production.
 */

// But their are other ways we can do this to eliminate the noise from the production code.
/*
 All of this debug flags can be moved to another class.
 // DebuggingSceneDelegate this class is a subclass of SceneDelegate.
 
 So we are extending the Scene Delegate and moving the debug logic to the debugSceneDelegate.
 
 So we have a lot of trade-offs when using black-box testing, because we need to have test code in production target.
 */

/*
 This test's are flaky as we cound have no internet connection while running the app, or in our case testing the cell count that we are getting from server so they can change.
 
 So these test are flaky and can't pass own its own. So this is fragile.
 
 This is fragile and being in a specific state ideally we epxect it to run again and again and get same result every time.
 
 We want to reduce and eliminate flakiness.
 So we need to decouple our UITest from specific Backend.
 */

// MARK: - UI test should not test low level detail.
// It should always test high level acceptance criteria.

// So we can have connectivity state and have some predefined reponses.

// MARK: - Intercept HTTP responses with canned response to eliminate network flakiness
/*
 After decoupling.
 1. Those test does nto depend on server state.
 2. Or the network state.
 
 They would't fail because of extrenal system.
 */

/*
 We have written very high level test and we are not checking values and text and things like that.
 All this test have been tested either in isolation on in unit Tests or integration tests.
 */

// MARK: - UI Test that actually run the app should only test high level acceptance criteria.

// To make sure your black box UI test are reliable, you need to limit the production behaviour you replace during tests.
// Ideally you should replace infrastructure details like HTTPClient or the cache state.
