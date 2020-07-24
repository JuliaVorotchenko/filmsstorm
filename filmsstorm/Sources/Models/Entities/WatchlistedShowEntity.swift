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
    class func findOrCreate(_ item: ShowListResult, context: NSManagedObjectContext) throws -> WatchlistedShowEntity {
        
         if let showEntity = try? WatchlistedShowEntity.find(id: item.id, context: context) {
                   return showEntity
               } else {
                   let showEntity = WatchlistedShowEntity(context: context)
                   showEntity.id = Int32(item.id)
                   showEntity.name = item.name
                   showEntity.originalName = item.originalName
                   showEntity.overview = item.overview
                   showEntity.rating = item.voteAverage ?? 5.5
                   showEntity.releaseDate = item.firstAirDate
                   showEntity.posterImage = item.posterImage
                   showEntity.backgroundImage = item.backgroundImage
                   return showEntity
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