//
//  ModalViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 11/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit
import SDWebImage

class ModalViewController: UIViewController {
    
    var heroImage: String?
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        pintAll()
        
    }
    private func pintAll(){
        img?.sd_setImage(with: URL(string: self.heroImage!),  placeholderImage: nil, options: [], completed: nil)
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion:nil)
    }
    
   
    
    
    
}
