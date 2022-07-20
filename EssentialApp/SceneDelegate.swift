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
import Combine

/*
 lazy var so if they ar ento set we have the change to instanciate them lazily.
 */
/*
 all this init and below code is to replace UIAccpetance test with UIIntegration Test
 */

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
        guard let scene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        
        // let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        self.httpClient = makeRemoteClient()
        
        // let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: self.httpClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: self.httpClient)

        // let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader)))
        
        let rootController = UINavigationController(rootViewController: feedViewController)
        window?.rootViewController = rootController
        
        window?.makeKeyAndVisible()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient // URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache(completion: { _ in })
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher { // AnyPublisher<[FeedImage], Error>
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: self.httpClient)
        
        // Wrap feedloader in to a publisher.
        // We are wrapping publishers in side a publisher just like we were wrapping our abstractions with decorators, composites and adapters.
        // Wrapping the type to another type to change it's behaviour.
        
        /*
        return Deferred {
            Future { completion in
                remoteFeedLoader.load(completion: completion)
            }
        }
        .eraseToAnyPublisher() */
        
        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .failure(to: localFeedLoader.loadPublisher)
    }
    // we just wrapped the load function into combine publisher.
    // we still need to perform composition with cache and the fallback.
}

extension RemoteLoader: FeedLoader where Resource == [FeedImage] { }
