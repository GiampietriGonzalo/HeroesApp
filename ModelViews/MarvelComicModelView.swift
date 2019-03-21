//
//  MarvelComicModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

class MarvelComicModelview: ComicModelView{

    private var myComics: [Comic]?
    private var myManager: SuperheroManager?
    
    init(){
        myManager = SuperheroManager()
    }

    func getComicsCount() -> Int {
        return myComics?.count ?? 0
    }
    
    func lookForComics(completion: @escaping () -> ()){
        
        myManager?.getComics() { [weak self] comicsCollection in
            
            guard let mySelf = self else {
                return
            }
            
            mySelf.myComics = comicsCollection

            completion()
        }
     
        
    }
    

    func getComicAt(index: Int) -> Comic? {
        return myComics?[index] ?? nil
    }
    
    func initComicCell(cell: ComicCollectionCell, row: Int){
        
        if let comics = myComics {
            cell.comicImage.sd_setImage(with: URL(string: comics[row].thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
