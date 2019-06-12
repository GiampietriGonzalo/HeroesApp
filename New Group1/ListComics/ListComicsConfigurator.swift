//
//  ListComicsConfiger.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//
import UIKit

class ListComicsConfigurator: Configurator {
    
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
