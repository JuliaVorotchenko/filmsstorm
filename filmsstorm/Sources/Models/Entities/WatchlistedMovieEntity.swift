//
//  WatchlistedMovieEntity.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import CoreData

class WatchlistedMovieEntity: NSManagedObject {
    class func findOrCreate(_ item: MovieListResult, context: NSManagedObjectContext) throws -> WatchlistedMovieEntity {
        
        if let movieEntity = try? WatchlistedMovieEntity.find(id: item.id, context: context) {
            return movieEntity
        } else {
            let movieEntity = WatchlistedMovieEntity(context: context)
            movieEntity.id = Int32(item.id)
            movieEntity.name = item.title
            movieEntity.originalName = item.originalTitle
            movieEntity.overview = item.overview
            movieEntity.rating = item.voteAverage ?? 5.5
            movieEntity.releaseDate = item.releaseDate
            movieEntity.posterImage = item.posterImage
            movieEntity.backgroundImage = item.backDropPath
            return movieEntity
        }
    }
    
    class func deleteItem(_ id: Int, context: NSManagedObjectContext) {
        if let movieEntity = try? WatchlistedMovieEntity.find(id: id, context: context) {
            do {
                context.delete(movieEntity)
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("no such item")
        }
    }
    
    class func addItem(_ item: FavoriteItem, context: NSManagedObjectContext) {
        if let movieEntity = try? WatchlistedMovieEntity.find(id: Int(item.id), context: context) {
            do {
                context.insert(movieEntity)
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("no such item")
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [WatchlistedMovieEntity] {
        let request: NSFetchRequest<WatchlistedMovieEntity> = WatchlistedMovieEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(id: Int, context: NSManagedObjectContext) throws -> WatchlistedMovieEntity? {
        let request: NSFetchRequest<WatchlistedMovieEntity> = WatchlistedMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %id", id)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if !fetchResult.isEmpty {
                assert(fetchResult.count == 1, "Duplicate has been found in DB")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func delete(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteMovieEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
