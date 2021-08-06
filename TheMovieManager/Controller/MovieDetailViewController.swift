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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movie: Movie!
    var saveObserverToken: Any?
    
    var isWatchlist: Bool {
        return movie.watchlist
    }
    
    var isFavorite: Bool {
        return movie.favorite
    }
    
    fileprivate func startLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        self.startLoading(true)
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
        let placeHolder = UIImage(named: "PosterPlaceholder")
        
        if let posterPath = movie.posterPath {
            imageView.kf.setImage(with: K.ProductionServer.resolvePoster(posterPath)) {
                result in
                self.startLoading(false)
                
                switch result {
                case .failure(let error):
                    // on failure:
                    // show the default image
                    self.imageView.image = placeHolder
                    
                    // notify user of the error
                    var message = error.localizedDescription
                    
                    // clean up error message for no internet connection
                    if message.contains("offline") {
                        message = "No internet connection"
                    } else if message.contains("request timed out") {
                        message = "The request timed out"
                    }
                    
                    self.alertError(title: "Failed to download poster image", message: message)
                    break
                default:
                    break
                }
            }
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
        
        if let error = error {
            self.alertError(title: "Watchlist Update Failed", message: error.localizedDescription)
        }
    }
    
    func handleFavoriteResponse(success: Bool, error: Error?) {
        if success {
            movie.update(favorite: !isFavorite)
        }
        
        if let error = error {
            self.alertError(title: "Favorite List Update Failed", message: error.localizedDescription)
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
