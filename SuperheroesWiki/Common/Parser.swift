//
//  Parser.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 23/05/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit

protocol Parser{
    func parse<T: Decodable>(this: Data, type: T.Type, at: Int) -> T?
}
class ParserImp: Parser{
    private let decoder : JSONDecoder

    init(){
        decoder = JSONDecoder()
        //TODO Dependecy injection para CONTEXT
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        decoder.userInfo[CodingUserInfoKey.context!] = context
    }
    
    func parse<T: Decodable>(this: Data, type: T.Type, at: Int) -> T? {
        var parsedData: T?
        do{
            parsedData = try decoder.decode(T.self, from: this)
        } catch {
            print(Messages.DECODE_ERROR_MESSAGE)
        }
        return parsedData
    }
}
