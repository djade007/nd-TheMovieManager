//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    var saveObserverToken: Any?
    
    var isWatchlist: Bool {
        return movie.watchlist
    }
    
    var isFavorite: Bool {
        return movie.favorite
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
        if let posterPath = movie.posterPath {
            let placeHolder = UIImage(named: "PosterPlaceholder")
            
            imageView.kf.setImage(with: K.ProductionServer.resolvePoster(posterPath), placeholder: placeHolder)
        }
        
        addSaveNotificationObserver()
    }
    
    // MARK: LifeCycles
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(movieId: Int(movie.id), watchlist: !isWatchlist, completion: handleWatchlistResponse(success:error:))
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markFavorite(movieId: Int(movie.id), favorite: !isFavorite, completion: handleFavoriteResponse(success:error:))
    }
    
    // MARK: Reponse handlers
    func handleWatchlistResponse(success: Bool, error: Error?) {
        if success {
            movie.update(watchList: !isWatchlist)
        }
    }
    
    func handleFavoriteResponse(success: Bool, error: Error?) {
        if success {
            movie.update(favorite: !isFavorite)
        }
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    deinit {
        removeSaveNotificationObserver()
    }
}


// MARK: Notfication observers
extension MovieDetailViewController {
    func addSaveNotificationObserver() {
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: DataController.shared.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver() {
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    fileprivate func reloadActions() {
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
    }
    
    func handleSaveNotification(notification:Notification) {
        DispatchQueue.main.async {
            self.reloadActions()
        }
    }
}
