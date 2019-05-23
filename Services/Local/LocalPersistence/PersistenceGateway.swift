//
//  PersistanceGateway.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 23/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
protocol PersistenceGateway {
    func store()
    func fetch()
    func update()
    func delete(onlyFirstValue: Bool)
    func saveContext()
}


