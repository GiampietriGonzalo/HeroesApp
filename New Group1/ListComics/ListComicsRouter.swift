//
//  ListComicsRouter.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

protocol ListComicsRouterProtocol: ViewControllerRouter {
    func goToController(with segue: UIStoryboardSegue, withData: ListComicsOutput?)
}

class ListComicsRouter: ListComicsRouterProtocol{
    
    func goToController(with segue: UIStoryboardSegue, withData comicsListOutput: ListComicsOutput?) {
        guard let segueId = segue.identifier, let id = SegueId(rawValue: segueId) else{
            return
        }
        
        switch id {
        case .listComicsToComicDetails:
            let destiny = segue.destination as? ComicDetailsViewController
            destiny?.input = ComicDetailsInput(comic: comicsListOutput?.comic)
        default:
            break
        }
    }
}
