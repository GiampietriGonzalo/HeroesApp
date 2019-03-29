//
//  SuperheroManager.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 07/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SuperheroManager {
 
    private var superheroes: [Hero] = []
    private let myClient: APIClient
    private typealias serviceResponse = ([Hero]?, Error?) -> Void

    init(){
        myClient = APIClient()
    }
    
    func getSuperheroesFromAPI(completion: @escaping ([Hero]) -> Void) {
        
        myClient.getSuperheroes{ [weak self] (heroesSet,error) in
            
            guard let myHeroes = heroesSet, let mySelf = self else {
                return
            }
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            else{
                mySelf.getHeroesFromSetResult(setResult: myHeroes)
                completion(mySelf.superheroes)
            }
        }
    }
    
    private func getHeroesFromSetResult(setResult: Set<Hero>){
        
        for hero in setResult{
            superheroes.append(hero)
        }
    }

    func getComicsFromHero(heroID: Int32, completion: @escaping ([Comic]?) -> Void){
        myClient.getComicsHero(heroID: heroID ) { (heroComics,error) in
            
            if let error = error{
                print("Error en la request de los comics por ID\n\(error.localizedDescription)")
            }
           completion(heroComics)
        }
    }
    

    func getComics(completion: @escaping ([Comic]?) -> Void) {
        
        myClient.getComics() { (heroComics,error) in
            
            if let error = error{
                print("Error en la request de los comics de los comics :  \n \(error.localizedDescription)")
            }
            completion(heroComics)
        }
    }
    
    func getwikiHero(hero:Hero,  completion: @escaping (String?) -> Void){
        
        myClient.getWiki(hero: hero){ (wikiUrl,error) in
            
            if error != nil{
                print("Error en la request de la wiki :  \n \(error!.localizedDescription)")
            }
            completion(wikiUrl)
        }
    }
    
    func getHeroByID(heroID: Int32, completion: @escaping (Hero) -> Void){
        
        myClient.searchHerobyID(heroID: heroID){ hero in
            
            guard let myHero = hero else{
                return
            }
            completion(myHero)
        }
    }
}
