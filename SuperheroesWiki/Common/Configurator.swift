//
//  Configurator.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

protocol Configurator {
    static func configure(controller: UIViewController, with input: Input?)
}
