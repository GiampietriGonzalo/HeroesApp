//
//  SuperheroManager.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 07/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

/*class SuperheroManager {
 
    private var superheroes: [Hero] = []
    private let myClient: APIClient
    private typealias serviceResponse = ([Hero]?, Error?) -> Void

    init(){ myClient = APIClient() }
    
    func getSuperheroesFromAPI(completion: @escaping ([Hero]) -> Void) {
        myClient.getSuperheroes{ [weak self] (heroesSet) in
            guard let myHeroes = heroesSet, let mySelf = self else {  return }
            mySelf.getHeroesFromSetResult(setResult: myHeroes)
            completion(mySelf.superheroes)
        }
    }
    
    private func getHeroesFromSetResult(setResult: Set<Hero>){
        for hero in setResult{
            superheroes.append(hero)
        }
    }

    func getComicsFromHero(heroID: Int32, completion: @escaping ([Comic]?) -> Void){
        myClient.getComicsOfHero(heroID: heroID ) { (heroComics) in
           completion(heroComics)
        }
    }
    

    func getComics(completion: @escaping ([Comic]?) -> Void) {
        myClient.getComics() { (heroComics) in
            completion(heroComics)
        }
    }
    
    func getwikiHero(hero:Hero,  completion: @escaping (String?) -> Void){
        myClient.getWikiOfHero(heroName: hero.name){ (wikiUrl) in
            completion(wikiUrl)
        }
    }
    
    func getHeroByID(heroID: Int32, completion: @escaping (Hero) -> Void){
        myClient.getHeroByID(heroID: heroID){ hero in
            guard let myHero = hero else{ return }
            completion(myHero)
        }
    }
}*/
