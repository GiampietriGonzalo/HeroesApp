//
//  ComicViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 06/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit
import SDWebImage

class ComicViewController: UIViewController {

  
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pintAll()
        
    }

    private func pintAll(){
       
        guard let myComic = comic else{
            return
        }
        
        image.sd_setImage(with: URL(string: self.comic!.thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
        
        titleLabel.text = myComic.title
        descriptionLabel.text = "DESCRIPTION\n\(myComic.comicDescription ?? "")"
        idLabel.text = "ID: \(myComic.id)"
        
    }
    
}


