//
//  ComicsParser.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

class ComicsParser: Parser {
    private let decoder = JSONDecoder()
    
    func parse(this: Data) -> Decodable {
        return try? self.decoder.decode(ComicsResponse.self, from: this)
    }
}
