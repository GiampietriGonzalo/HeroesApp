//
//  Parser.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

protocol Parser {
    func parse(this: Data) -> Decodable
}
