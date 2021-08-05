//
//  WatchlistViewController.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import UIKit
import CoreData

class WatchlistViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var fetchedResultsController:NSFetchedResultsController<Movie>!
    
    fileprivate func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: false)
        
        fetchRequest.predicate = NSPredicate(format: "watchlist = true")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "movies-watchlist")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetch for watchlist could not be performed \(error.localizedDescription)")
        }
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchResultsController()
    
        // Update records
        TMDBClient.getWatchlist() { movies, error in
            movies.forEach() {
                (item) in
                item.saveOrUpdateMovie(watchList: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedResultsController.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController.delegate = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! MovieDetailViewController
            
            if let selectedIndex = tableView.indexPathForSelectedRow {
                detailVC.movie = fetchedResultsController.object(at: selectedIndex)
                
                tableView.deselectRow(at: selectedIndex, animated: true)
            }
        }
    }
    
}

// Mark: TableView Delegates
extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        
        let movie = fetchedResultsController.object(at: indexPath)
        let placeHolder = UIImage(named: "PosterPlaceholder")
        
        cell.textLabel?.text = movie.title
        cell.imageView?.image = placeHolder
        
        if let posterPath = movie.posterPath {
            cell.imageView?.kf.setImage(with: K.ProductionServer.resolvePoster(posterPath), placeholder: placeHolder) {
                result in
                switch result {
                case .success:
                    cell.setNeedsLayout()
                    break
                default:
                    break
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}


// Mark: NSFetchedResultsControllerDelegate
extension WatchlistViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default: break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
