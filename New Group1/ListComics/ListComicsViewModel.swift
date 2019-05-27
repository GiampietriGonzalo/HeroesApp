//
//  MarvelComicModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

class ListComicsViewModel: ListComicsViewModelProtocol{

    private var comicsList: [Comic]?
    private var dataProvider: HeroesDataProvider?
    
    init(){
        //TODO DEPENDENCY INJECTION
        dataProvider = MarvelAPIClient()
    }

    func getComicsCount() -> Int {
        return comicsList?.count ?? 0
    }
    
    func lookForComics(completion: @escaping () -> ()){
        dataProvider?.getComics() { [weak self] comicsCollection in
            guard let mySelf = self else { return }
            mySelf.comicsList = comicsCollection
            completion()
        }
    }

    func getComicAt(index: Int) -> Comic? {
        return comicsList?[index] ?? nil
    }
    
    func initComicCell(cell: ComicCollectionCell, row: Int){
        if let comics = comicsList {
            cell.comicImage.sd_setImage(with: URL(string: comics[row].thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
        }
    }
}
