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
    
    func saveFavoriteMovies(movies: [MovieListResult]) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for movie in movies {
                _ = try? FavoriteMovieEntity.findOrCreate(movie, context: viewContext)
            }
            try? viewContext.save()
        }
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
    
    func saveFavoriteShows(shows: [FavoriteItem], completionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for show in shows {
                _ = try? FavoriteShowEntity.findOrCreate(show, context: viewContext)
            }
            try? viewContext.save()
            completionHandler()
        }
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
    
    func saveWatchlistedMovies(movies: [FavoriteItem], completionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for movie in movies {
                _ = try? WatchlistedMovieEntity.findOrCreate(movie, context: viewContext)
            }
            try? viewContext.save()
            completionHandler()
        }
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
    
    func saveWatchlistedShows(shows: [FavoriteItem], completionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for show in shows {
                _ = try? WatchlistedShowEntity.findOrCreate(show, context: viewContext)
            }
            try? viewContext.save()
            completionHandler()
        }
    }
    
    // MARK: - Upcomong Movies
    
    // MARK: - Popular Shows
    
    // MARK: - Popular Movies
}
