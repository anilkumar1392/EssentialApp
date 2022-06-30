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
    // we jsut wrapped the load function into combine publisher.
    // we still need to perform composition with cache and the fallback.
    
    

}

extension FeedLoader {
    public typealias Publisher = AnyPublisher<[FeedImage], Error>
    
    public func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                self .load(completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}


// Configure with decorator
extension Publisher where Output == [FeedImage] {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> {
//        map { feed in
//            cache.saveIgnoringResult(feed)
//            return feed
//        }
//        .eraseToAnyPublisher()
        
//        handleEvents(receiveOutput: { feed in
//            cache.saveIgnoringResult(feed)
//        })
//        .eraseToAnyPublisher()

        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

// Configure for fallback
extension Publisher {
    func failure(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueSchedular {
        ImmediateWhenOnMainQueueSchedular()
    }
    
    struct ImmediateWhenOnMainQueueSchedular: Scheduler {

        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        /// This scheduler’s definition of the current moment in time.
        var now: Self.SchedulerTimeType {
            DispatchQueue.main.now
        }

        /// The minimum tolerance allowed by the scheduler.
        var minimumTolerance: Self.SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }

        /// Performs the action at the next possible opportunity.
        func schedule(options: Self.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard Thread.isMainThread else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }

        /// Performs the action at some time after the specified date.
        func schedule(after date: Self.SchedulerTimeType, tolerance: Self.SchedulerTimeType.Stride, options: Self.SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        /// Performs the action at some time after the specified date, at the specified frequency, optionally taking into account tolerance if possible.
        func schedule(after date: Self.SchedulerTimeType, interval: Self.SchedulerTimeType.Stride, tolerance: Self.SchedulerTimeType.Stride, options: Self.SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
