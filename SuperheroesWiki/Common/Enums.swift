//
//  Enums.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 28/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation

enum SegueId: String {
    case heroDetailsToComicDetails = "comicSegue"
    case heroDetailsToImageZoomed = "tapSegue"
    case heroDetailsToHeroWiki = "heroWikiSegue"
    case listComicsToComicDetails = "comicDetailSegue"
    case listHeroesToHeroDetails = "detailSegue"
}

