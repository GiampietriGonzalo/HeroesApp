//
//  ComicsDetailsConfigurator.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

class ComicDetailsConfigurator: Configurator {
    
    static func configure(controller: UIViewController, with input: Input?) {
        let controller = controller as? ComicDetailsViewController
        controller?.presenter = initPresenter(with: input) as? ComicDetailsPresenter
    }
    
    private static func initPresenter(with input: Input?) -> Presenter {
        let presenter = ComicDetailsPresenter()
        let input = input as? ComicDetailsInput
        presenter.comic = input?.comic
        return presenter
    }
}
