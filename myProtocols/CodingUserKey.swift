//
//  CodingUserKey.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

/**
 Necesitamos definir una CodingUserInfoKey nueva para poder guardar nuestro context en el decoder.
 Entonces declaramos una extension de CodingUserInfoKey y una key nueva estatica
 */
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
