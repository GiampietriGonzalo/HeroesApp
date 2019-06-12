//
//  ListComicsViewControllerProtocol.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

struct ListComicsOutput: Output {
    var comic: Comic
}
protocol ListComicsViewControllerProtocol {
    var router: ListComicsRouterProtocol? {get set}
}
