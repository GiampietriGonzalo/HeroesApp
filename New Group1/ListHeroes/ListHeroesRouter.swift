//
//  ListHeroesRouter.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 03/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

protocol ListHeroesRouterProtocol: ViewControllerRouter {
    func goToController(with segue: UIStoryboardSegue, withData: ListHeroesOutput?)
}

class ListHeroesRouter: ListHeroesRouterProtocol {
    
    func goToController(with segue: UIStoryboardSegue, withData heroesListOutput: ListHeroesOutput?) {
        
        guard let segueId = segue.identifier, let id = SegueId(rawValue: segueId) else{
            return
        }
        
        switch id {
        case .listHeroesToHeroDetails:
            let destiny = segue.destination as? HeroDetailsViewController
            pass(data: heroesListOutput, to: destiny)
        default: break
        }
    }
    
    private func pass(data: ListHeroesOutput?, to controller: HeroDetailsViewController?) {
        
    }
}
