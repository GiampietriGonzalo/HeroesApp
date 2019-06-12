//
//  ComicDetailsInteractor.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol ComicDetailsPresenterProtocol: Presenter {
    func getComicID() -> Int32?
    func getComicTitle() -> String?
    func getComicDescription() -> String?
}

class ComicDetailsPresenter: ComicDetailsPresenterProtocol {
    var controller: ComicDetailsPresenterProtocol?
    var comic: Comic?
    
    func getComicID() -> Int32? {
        return comic?.id
    }
    
    func getComicTitle() -> String? {
        return comic?.title
    }
    
    func getComicDescription() -> String? {
        return comic?.comicDescription
    }
    
    func getComicUrlImage() -> String? {
        return comic?.thumbnail.completePath()
    }
}
