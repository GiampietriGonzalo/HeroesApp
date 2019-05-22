//
//  Connectivity.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 21/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return  NetworkReachabilityManager()!.isReachable
    }
}
