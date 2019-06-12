//
//  ListHeroesConfigurator.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit


class ListHeroesConfigurator: Configurator {
    
    static func configure(controller: UIViewController, with input: Input?) {
        let controller = controller as? ListComicsViewController
        controller?.router = initRouter() as? ListComicsRouter
        controller?.interactor = initInteractor() as? ListComicsInteractor
    }
    
    private static func initInteractor() -> Interactor {
        return ListComicsInteractor(dataProvider: MarvelAPIClient())
    }
    
    private static func initRouter() -> ViewControllerRouter {
        return ListComicsRouter()
    }
}
