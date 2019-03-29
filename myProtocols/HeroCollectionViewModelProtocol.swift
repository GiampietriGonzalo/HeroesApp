//
//  HeroCollectionViewModelProtocol.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 22/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol HeroCollectionViewModelProtocol {
    
    func lookForHeroes(completion: @escaping () -> ())
    func getHeroesCount() -> Int
    func getHeroesCollection() -> [Hero]?
    func getHeroUrlImage(atIndex: Int) -> String?
    func getHeroName(indexAt: Int) -> String?
    func getHero(index: Int) -> Hero?
    func searchLogic(searchText: String, completion: @escaping () -> ())
    func addNotificaciont(tag: Int)
}

