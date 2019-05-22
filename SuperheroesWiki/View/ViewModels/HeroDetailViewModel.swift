//
//  HeroModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

class HeroDetailViewModel: HeroDetailViewModelProtocol {
   
    private let heroManager = SuperheroManager()
    private var myHero: Hero?
    private var urlWiki: String?
    private var comicsHero: [Comic]?
    private var heroID : Int32?
    
    init(hero: Hero?){
        myHero = hero
    }
    
    init(heroID: Int32) {
        self.heroID = heroID
    }
    
    func getHeroID() -> Int32 {
        return myHero?.id ?? 0
    }
    
    func getHeroName() -> String {
        return myHero?.name ?? "NAME NOT FOUND"
    }
    
    func getHeroDescription() -> String {
        return myHero?.heroDescription ?? "DESCRIPTION NOT FOUND"
    }
    
    func getHeroUrlImage() -> String {
        return myHero?.thumbnail.completePath() ?? "IMAGE NOT FOUND"
    }
    
    func getComicUrlImage(atIndex: Int) -> String {
        return comicsHero?[atIndex].thumbnail.completePath() ?? "IMAGE NOT FOUND"
    }
    
    func lookForWiki(completion: @escaping (String?) -> ()){
        guard let hero = myHero else { return }
        heroManager.getwikiHero(hero: hero){ [weak self] (urlGiven) in
            guard let mySelf = self else { return }
            mySelf.urlWiki = urlGiven
            completion(mySelf.urlWiki)
        }
    }
    
    func lookForComics(completion: @escaping () -> ()){
        guard let hero = myHero else { return }
        heroManager.getComicsFromHero(heroID: hero.id) { [weak self] comicArray in
            guard let mySelf = self else { return }
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
    
    func lookForHero(heroReady: @escaping () -> Void){
        
        if(myHero != nil){
            heroReady()
        } else {
            heroManager.getHeroByID(heroID: heroID ?? 0) { [weak self] hero in
                guard let mySelf = self else { return }
                mySelf.myHero = hero
                heroReady()
            }
        }
    }
}
