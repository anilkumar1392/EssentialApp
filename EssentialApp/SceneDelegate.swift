//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by 13401027 on 23/06/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let remoteClient = makeRemoteClient() // URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        // Compilation directives to prevent this code from being deployed on production.
        #if DEBUG
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        #endif
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader),
                fallback: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader)))
        
        /*
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: remoteFeedLoader,
            imageLoader: remoteImageLoader) */
        
         
        window?.rootViewController = feedViewController
    }
    
    private func makeRemoteClient() -> HTTPClient {
        #if DEBUG
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return AlwaysFailingHTTPClient()
        }
        #endif
        
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }

}

// We can also create retry logic with with.

/*
 let feedViewController = FeedUIComposer.feedComposedWith(
     feedLoader: FeedLoaderWithFallbackComposite(
         primary: remoteFeedLoader,
         fallback: FeedLoaderWithFallbackComposite(
             primary: remoteFeedLoader,
             fallback: localFeedLoader)),
     imageLoader: FeedImageDataLoaderWithFallbackComposite(
         primary: localImageLoader,
         fallback: remoteImageLoader))
 */

#if DEBUG
private class AlwaysFailingHTTPClient: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() { }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        return Task()
    }
}
#endif

// This code is not going to be deployed in production.
