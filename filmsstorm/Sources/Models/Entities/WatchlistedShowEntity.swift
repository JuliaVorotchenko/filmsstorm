//
//  WatchlistedShowEntity.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import CoreData

class WatchlistedShowEntity: NSManagedObject {
    class func findOrCreate(_ item: FavoriteItem, context: NSManagedObjectContext) throws -> WatchlistedShowEntity {
        
        if let movieEntity = try? WatchlistedShowEntity.find(id: item.id, context: context) {
            return movieEntity
        } else {
            let movieEntity = WatchlistedShowEntity(context: context)
            movieEntity.id = Int16(item.id)
            movieEntity.name = item.name
            movieEntity.originalName = item.originalName
            movieEntity.overview = item.overview
            movieEntity.rating = item.rating
            movieEntity.releaseDate = item.releaseDate
            movieEntity.posterImage = item.posterImage?.pngData()
            movieEntity.backgroundImage = item.backgroundImage?.pngData()
            return movieEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [WatchlistedShowEntity] {
        let request: NSFetchRequest<WatchlistedShowEntity> = WatchlistedShowEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(id: Int, context: NSManagedObjectContext) throws -> WatchlistedShowEntity? {
        let request: NSFetchRequest<WatchlistedShowEntity> = WatchlistedShowEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %id", id)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if fetchResult.isEmpty {
                assert(fetchResult.count == 1, "Duplicate has been found in DB")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
