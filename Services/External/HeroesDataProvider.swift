//
//  HeroesDataProvider.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 23/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
protocol HeroesDataProvider {
    func getSuperheroes(completion: @escaping CompletionAlias.HeroesRequestCompletion)
    func getComicsOfHero(heroID: Int32, completion: @escaping CompletionAlias.ComicsRequestCompletion)
    func getComics(completion: @escaping CompletionAlias.ComicsRequestCompletion)
    func getWikiOfHero(heroName: String, completion: @escaping CompletionAlias.WikiRequestCompletion)
    func getHeroByID(heroID: Int32,completion: @escaping CompletionAlias.HeroRequestCompletion)
}

