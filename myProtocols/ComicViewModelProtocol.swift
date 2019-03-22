//
//  ComicModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

protocol ComicViewModelProtocol: class {
    
    func getComicsCount() -> Int
    func lookForComics(completion: @escaping () -> ())
    func getComicAt(index: Int) -> Comic?
    func initComicCell(cell: ComicCollectionCell, row: Int)
    
}
