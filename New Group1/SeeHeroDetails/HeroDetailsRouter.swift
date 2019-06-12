//
//  HeroDetailRouter.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 04/06/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

protocol HeroDetailsRouterProtocol: ViewControllerRouter {
    func goToController(with segue: UIStoryboardSegue, withData heroDetailsOutput: HeroDetailsOutput?)

}

class HeroDetailsRouter: HeroDetailsRouterProtocol {
    
    func goToController(with segue: UIStoryboardSegue, withData heroDetailsOutput: HeroDetailsOutput?) {
        
        guard let segueId = segue.identifier, let id = SegueId(rawValue: segueId) else{
            return
        }
        
        switch id {
        case .listComicsToComicDetails:
            let destiny = segue.destination as? ComicDetailsViewController
            destiny?.input = ComicDetailsInput(comic: heroDetailsOutput?.comic)
        case .heroDetailsToImageZoomed:
            let destiny = segue.destination as? HeroImageViewController
            destiny?.heroImage = heroDetailsOutput?.hero?.thumbnail.completePath()
        default:
            break
        }
    }
}
