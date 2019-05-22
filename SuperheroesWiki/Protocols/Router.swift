//
//  Router.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 29/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
    func zoomHeroImage(segue: UIStoryboardSegue)
    func goToWiki(segue: UIStoryboardSegue, sender: Any?)
    func goToComicDetail(segue: UIStoryboardSegue)
}

/*class segueRouter: Router{
    
    func zoomHeroImage(segue: UIStoryboardSegue) {
        <#code#>
    }
    
    func goToWiki(segue: UIStoryboardSegue, sender: Any?) {
        
        guard let myCell = sender as? ComicCollectionCell ,let index = comicsCollection.indexPath(for: myCell)?.row else {
            return
        }
        
        let myVC = segue.destination as? ComicViewController
        myVC?.comic = heroModelView?.getComicAt(index: index)
    }
    
    func goToComicDetail(segue: UIStoryboardSegue) {
        <#code#>
    }
    
    
    
    
}*/
