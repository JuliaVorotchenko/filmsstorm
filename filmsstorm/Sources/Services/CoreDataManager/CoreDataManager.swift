//
//  CoreDataManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "filmsstorm")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private init() {}
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Favorite Movies
    
    func getFavoriteMovies(_ completionHandler: @escaping ([FavoriteItem?]) -> Void) {
        let viewContext = persistentContainer.viewContext
        persistentContainer.viewContext.perform {
            let movieEntities = try? FavoriteMovieEntity.all(viewContext)
            let movies = movieEntities?.map({FavoriteItem(entity: $0)})
            completionHandler(movies ?? [])
        }
    }
    
    func getFavMov() -> [FavoriteItem]? {
        let viewContext = persistentContainer.viewContext
        var shows: [FavoriteItem]? = []
        persistentContainer.viewContext.perform {
            let showEnities = try? FavoriteShowEntity.all(viewContext)
            shows = showEnities?.compactMap({FavoriteItem(entity: $0)})
        }
        return shows
    }
    
    func saveFavoriteMovies(movies: [MovieListResult]) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for movie in movies {
                _ = try? FavoriteMovieEntity.findOrCreate(movie, context: viewContext)
            }
            try? viewContext.save()
        }
    }
    
    func addFavMovie(item: MediaItemModel) {
        let viewContext = persistentContainer.viewContext
        guard let movie = FavoriteItem.init(mediaItemModel: item) else { return }
        viewContext.perform {
            FavoriteMovieEntity.addItem(movie, context: viewContext)
        }
    }
    
    
    func delete() {
        let viewContext = persistentContainer.viewContext
        FavoriteMovieEntity.delete(context: viewContext)
    }
    
    func deleteMovieFromFavorites(id: Int) {
        let viewContext = persistentContainer.viewContext
        FavoriteMovieEntity.deleteItem(id, context: viewContext)
    }
    
    // MARK: - Favorite Shows
    
    func getFavoriteShows(_ completionHandler: @escaping ([FavoriteItem?]) -> Void) {
        let viewContext = persistentContainer.viewContext
        persistentContainer.viewContext.perform {
            let showEnities = try? FavoriteShowEntity.all(viewContext)
            let shows = showEnities?.map({FavoriteItem(entity: $0)})
            completionHandler(shows ?? [])
        }
    }
    
    func getFavShows() -> [FavoriteItem]? {
        let viewContext = persistentContainer.viewContext
        var shows: [FavoriteItem]? = []
        persistentContainer.viewContext.perform {
            let showEnities = try? FavoriteShowEntity.all(viewContext)
            shows = showEnities?.compactMap({FavoriteItem(entity: $0)})
        }
        return shows
    }
    
    func saveFavoriteShows(shows: [ShowListResult]) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for show in shows {
                _ = try? FavoriteShowEntity.findOrCreate(show, context: viewContext)
            }
            try? viewContext.save()
        }
    }
    
    func addFavShow(item: MediaItemModel) {
           let viewContext = persistentContainer.viewContext
           guard let show = FavoriteItem.init(mediaItemModel: item) else { return }
           viewContext.perform {
               FavoriteShowEntity.addItem(show, context: viewContext)
           }
       }
    
    func deleteShowFfromFavorite(id: Int) {
        let viewContext = persistentContainer.viewContext
        FavoriteShowEntity.deleteItem(id, context: viewContext)
    }
    
    
    // MARK: - Movies Watchlist
    
    func getMoviesWatchlist(_ completionHandler: @escaping ([FavoriteItem?]) -> Void) {
        let viewContext = persistentContainer.viewContext
        persistentContainer.viewContext.perform {
            let movieEntities = try? WatchlistedMovieEntity.all(viewContext)
            let movies = movieEntities?.map({FavoriteItem(entity: $0)})
            completionHandler(movies ?? [])
        }
    }
    
    func getmovWatchlist() -> [FavoriteItem]? {
        let viewContext = persistentContainer.viewContext
        var shows: [FavoriteItem]? = []
        persistentContainer.viewContext.perform {
            let showEnities = try? WatchlistedMovieEntity.all(viewContext)
            shows = showEnities?.compactMap({FavoriteItem(entity: $0)})
        }
        return shows
    }
    
    func saveWatchlistedMovies(movies: [MovieListResult]) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for movie in movies {
                _ = try? WatchlistedMovieEntity.findOrCreate(movie, context: viewContext)
            }
            try? viewContext.save()
        }
    }
    
    func addWatchlMovie(item: MediaItemModel) {
           let viewContext = persistentContainer.viewContext
           guard let movie = FavoriteItem.init(mediaItemModel: item) else { return }
           viewContext.perform {
               WatchlistedMovieEntity.addItem(movie, context: viewContext)
           }
       }
    
    func deleteMovieFromWatchlist(id: Int) {
        let viewContext = persistentContainer.viewContext
        WatchlistedMovieEntity.deleteItem(id, context: viewContext)
    }
    
    
    
    // MARK: - Shows WatchList
    
    func getShowsWatchlist(_ completionHandler: @escaping ([FavoriteItem?]) -> Void) {
        let viewContext = persistentContainer.viewContext
        persistentContainer.viewContext.perform {
            let showEnities = try? WatchlistedShowEntity.all(viewContext)
            let shows = showEnities?.map({FavoriteItem(entity: $0)})
            completionHandler(shows ?? [])
        }
    }
    
    func getShowWatchl() -> [FavoriteItem]? {
        let viewContext = persistentContainer.viewContext
        var shows: [FavoriteItem]? = []
        persistentContainer.viewContext.perform {
            let showEnities = try? WatchlistedShowEntity.all(viewContext)
            shows = showEnities?.compactMap({FavoriteItem(entity: $0)})
        }
        return shows
    }
    
    func saveWatchlistedShows(shows: [ShowListResult]) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for show in shows {
                _ = try? WatchlistedShowEntity.findOrCreate(show, context: viewContext)
            }
            try? viewContext.save()
        }
    }
    
    func addWatchlShow(item: MediaItemModel) {
        let viewContext = persistentContainer.viewContext
        guard let show = FavoriteItem.init(mediaItemModel: item) else { return }
        viewContext.perform {
            WatchlistedShowEntity.addItem(show, context: viewContext)
        }
    }
    
    func deleteShowFromWatchlist(id: Int) {
        let viewContext = persistentContainer.viewContext
        WatchlistedShowEntity.deleteItem(id, context: viewContext)
    }
    
    
    // MARK: - Upcomong Movies
    
    // MARK: - Popular Shows
    
    // MARK: - Popular Movies
}
