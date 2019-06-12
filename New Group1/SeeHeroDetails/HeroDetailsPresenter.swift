//
//  HeroModelView.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol HeroDetailPresenterProtocol: Presenter{
    func getHeroID() -> Int32
    func getHeroName() -> String
    func getHeroDescription() -> String
    func getHeroUrlImage() -> String
    func lookForWiki(completion: @escaping (String?) -> ())
    func lookForComics(completion: @escaping () -> ())
    func getComicAt(index: Int) -> Comic?
    func getComicsCount() -> Int
    func getUrlWiki() -> String
    func getComicUrlImage(atIndex: Int) -> String
    func lookForHero(heroReady: @escaping () -> Void)
}

class HeroDetailsPresenter: HeroDetailPresenterProtocol {
   
    private let dataProvider : HeroesDataProvider?
    private var myHero: Hero?
    private var urlWiki: String?
    private var comicsHero: [Comic]?
    private var heroID : Int32?
    
    init(hero: Hero?){
        myHero = hero
        dataProvider = MarvelAPIClient()
    }
    
    init(heroID: Int32) {
        self.heroID = heroID
        dataProvider = MarvelAPIClient()
    }
    
    func getHeroID() -> Int32 {
        return myHero?.id ?? 0
    }
    
    func getHeroName() -> String {
        return myHero?.name ?? Messages.NAME_NOT_FOUND
    }
    
    func getHeroDescription() -> String {
        return myHero?.heroDescription ?? Messages.DESCRIPTION_NOT_FOUND
    }
    
    func getHeroUrlImage() -> String {
        return myHero?.thumbnail.completePath() ?? Messages.IMAGE_NOT_FOUND
    }
    
    func getComicUrlImage(atIndex: Int) -> String {
        return comicsHero?[atIndex].thumbnail.completePath() ?? Messages.IMAGE_NOT_FOUND
    }
    
    func lookForWiki(completion: @escaping (String?) -> ()){
        guard let hero = myHero else { return }
        dataProvider?.getWikiOfHero(heroName: hero.name){ [weak self] (urlGiven) in
            guard let mySelf = self else { return }
            mySelf.urlWiki = urlGiven
            completion(mySelf.urlWiki)
        }
    }
    
    func lookForComics(completion: @escaping () -> ()){
        guard let hero = myHero else { return }
        dataProvider?.getComicsOfHero(heroID: hero.id) { [weak self] comicArray in
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
            dataProvider?.getHeroByID(heroID: heroID ?? 0) { [weak self] hero in
                guard let mySelf = self else { return }
                mySelf.myHero = hero
                heroReady()
            }
        }
    }
}
