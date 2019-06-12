//
//  ListHeroesViewControllerProtocol.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

struct ListHeroesOutput: Output {
    var hero: Hero
}
protocol ListHeroesViewControllerProtocol {
    var router: ListComicsRouterProtocol? {get set}
}
