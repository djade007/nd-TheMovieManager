//
//  UIViewController+Extension.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import UIKit
import CoreData


// Mark: Logout actions
extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        promptLogout()
    }
    
    private func promptLogout() {
        let alertVC = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            // api logout is optional
            // No need to wait for the response before proceeding with clearing user data
            TMDBClient.logout{}
            
            self.clearCoreData()
            Auth.shared.clear()
            
            self.goBackToLogin()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [logoutAction, cancelAction].forEach { alertVC.addAction($0) }
        present(alertVC, animated: true)
    }
    
    private func clearCoreData() {
        let context = DataController.shared.backgroundContext
        
        context.perform {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
                print("data has been cleared")
            } catch {
                print ("There was an error: \(error.localizedDescription)")
            }
        }
    }
    
    private func goBackToLogin() {
    
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
           
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = rootVC
            
            sceneDelegate.window?.makeKeyAndVisible()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // Mark: Error alerts
    func alertError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertVC, animated: true)
    }
    
}
