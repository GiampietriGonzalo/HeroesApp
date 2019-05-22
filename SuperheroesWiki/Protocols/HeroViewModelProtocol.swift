//
//  HeroViewmodelProtocol.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol HeroViewModelProtocol: class {
    
    func getHeroID() -> Int32
    func getHeroName() -> String
    func getHeroDescription() -> String
    func getHeroUrlImage() -> URL
    func lookForWiki(completion: () -> ())
    func lookForComics(completion: () -> ())
    func getHeroAt(index: int) -> Hero
    func getHeroesCount() -> Int
    
    
}
