//
//  HeroModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

class HeroDetailViewModel: HeroDetailViewModelProtocol {
    
    private let myManager = SuperheroManager()
    private var myHero: Hero?
    private var urlWiki: String?
    private var comicsHero: [Comic]?
    
    init(hero: Hero?){
        myHero = hero
        
    }
    
    func getHeroID() -> Int32 {
        return myHero?.id ?? 0
    }
    
    func getHeroName() -> String {
        return myHero?.name ?? ""
    }
    
    func getHeroDescription() -> String {
        return myHero?.heroDescription ?? ""
    }
    
    func getHeroUrlImage() -> String {
        return myHero?.thumbnail.completePath() ?? ""
    }
    
    func getComicUrlImage(atIndex: Int) -> String {
        return comicsHero?[atIndex].thumbnail.completePath() ?? ""
    }
    
    func lookForWiki(completion: @escaping (String?) -> ()){
        
        guard let hero = myHero else {
            return
        }
        
        myManager.getwikiHero(hero: hero){ [weak self] (urlGiven) in
            
            guard let mySelf = self else {
                return
            }
            
            mySelf.urlWiki = urlGiven
            completion(mySelf.urlWiki)
        }
        
    }
    
    func lookForComics(completion: @escaping () -> ()){
    
        guard let hero = myHero else {
            return
        }
        
        myManager.getComicsFromHero(heroID: hero.id) { [weak self] comicArray in
            
            guard let mySelf = self else {
                return
            }
            
            mySelf.comicsHero = comicArray
            
            completion()
        }
        
    }
    
    func getComicAt(index: Int) -> Comic? {
        return comicsHero?[index] ?? nil
    }
    
    func getComicsCount() -> Int{
        return comicsHero?.count ?? 0
    }
    func getUrlWiki() -> String{
        return urlWiki ?? ""
    }
    
}
