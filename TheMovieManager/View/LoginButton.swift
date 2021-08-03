//
//  LoginButton.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
