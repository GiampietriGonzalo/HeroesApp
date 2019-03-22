//
//  HeroModelViewProcol.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol HeroModelViewProtocol{
    
    func getHeroID() -> Int32
    func getHeroName() -> String
    func getHeroDescription() -> String
    func getHeroUrlImage() -> String
    func lookForWiki(completion: @escaping (String?) -> ())
    func lookForComics(completion: () -> ())
    func getComicAt(index: Int) -> Comic?
    func getComicsCount() -> Int
    func getUrlWiki() -> String
    
}
