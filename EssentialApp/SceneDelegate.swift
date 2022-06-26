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
    
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        configureWindow()
    }
    
    func configureWindow() {
        
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let remoteClient = makeRemoteClient() // URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        // let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
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
        
        let rootController = UINavigationController(rootViewController: feedViewController)
        window?.rootViewController = rootController
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient // URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache(completion: { _ in })
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

// This code is not going to be deployed in production.
