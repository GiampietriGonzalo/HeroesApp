//
//  Router.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 29/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerRouter {
}

protocol StoryboardRouter {
    func routeToStoryboard(to: UIStoryboard, with: UIStoryboardSegue)
}

