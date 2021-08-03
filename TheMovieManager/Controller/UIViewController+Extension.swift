//
//  UIViewController+Extension.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        TMDBClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
