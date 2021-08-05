//
//  Movie+Extension.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 04/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Movie {
    class func find(id: Int, context: NSManagedObjectContext) -> Movie? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let idPredicate = NSPredicate(format: "id = \(id)", argumentArray: nil)
        request.predicate = idPredicate
        var result: [AnyObject]?
        var movie: Movie? = nil
        
        do {
            result = try context.fetch(request)
        } catch let error as NSError {
            NSLog("Error getting match: \(error)")
            result = nil
        }
        if result != nil {
            for resultItem : AnyObject in result! {
                movie = resultItem as? Movie
            }
        }
        return movie
    }
    
    func update(favorite: Bool? = nil, watchList: Bool? = nil, image: Data? = nil) {
        let itemObjectId = objectID
        let backgroundContext = DataController.shared.backgroundContext
        
        backgroundContext.performAndWait {
            let backgroudMovie = backgroundContext.object(with: itemObjectId) as! Movie
            
            if let favorite = favorite {
                backgroudMovie.favorite = favorite
            }
            
            if let watchlist = watchList {
                backgroudMovie.watchlist = watchlist
            }
            
            if let image = image {
                backgroudMovie.poster = image
            }
            
            try? backgroundContext.save()
        }
    }
}


extension MovieResponse {
    
    func toMovie() -> Movie {
        let context = DataController.shared.viewContext
        if let movie = Movie.find(id: id, context: context) {
            return movie
        }
        
        let movie = Movie(context: context)
        movie.id = Int32(id)
        movie.posterPath = posterPath
        movie.title = title
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "yy-MM-dd"
        
        // Convert String to Date
        movie.releaseDate = dateFormatter.date(from: releaseDate)
        try? context.save()
        return movie
    }
    
    func saveOrUpdateMovie(favorite: Bool? = nil, watchList: Bool? = nil) {
        let backgroundContext = DataController.shared.backgroundContext
        
        if let movie = Movie.find(id: id, context: backgroundContext) {
            // Update favorite or watchlist
            backgroundContext.performAndWait {
                var updated = false
                
                if let favorite = favorite, movie.favorite != favorite {
                    movie.favorite = favorite
                    updated = true
                }
                
                if let watchlist = watchList, movie.watchlist != watchList {
                    movie.watchlist = watchlist
                    updated = true
                }
                
                // only update when value has been changed
                if updated {
                    try? backgroundContext.save()
                }
            }
            return
        }
        
        
        backgroundContext.performAndWait {
            let movie = Movie(context: backgroundContext)
            movie.id = Int32(id)
            movie.posterPath = posterPath
            if let favorite = favorite {
                movie.favorite = favorite
            }
            
            if let watchlist = watchList {
                movie.watchlist = watchlist
            }
            
            movie.title = title
            
            // Create Date Formatter
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "yy-MM-dd"

            // Convert String to Date
            movie.releaseDate = dateFormatter.date(from: releaseDate)
            
            try? backgroundContext.save()
        }
    
    }
}
