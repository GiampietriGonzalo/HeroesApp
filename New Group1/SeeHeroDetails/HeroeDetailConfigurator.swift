//
//  HeroeDetailConfigurator.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 04/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

class HeroDetailsConfigurator: Configurator {
    
    static func configure(controller: UIViewController, with input: Input?) {
        let controller = controller as? HeroDetailsViewController
        controller?.presenter = initPresenter(with: input) as? HeroDetailsPresenter
    }
    
    private static func initPresenter(with input: Input?) -> Presenter {
        let input = input as? HeroDetailsInput
        let presenter = HeroDetailsPresenter(hero: input?.hero, dataProvider: MarvelAPIClient())
        return presenter
    }
}
