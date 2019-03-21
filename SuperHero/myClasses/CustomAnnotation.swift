//
//  CustomAnnotation.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 14/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation{
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
  
    }
    
}
