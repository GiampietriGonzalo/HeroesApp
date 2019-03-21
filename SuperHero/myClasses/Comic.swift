//
//  Comic.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 01/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import CoreData

class ComicsResponse: NSManagedObject, CodableHasContextChecker, Decodable {
    
    
    @NSManaged var data: ComicsData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let ent = ComicsResponse.hasValidContext(decoder: decoder, entityName: "ComicsResponse") else {
            fatalError("Failed to decode Subject!")
        }
        
        /**
         INICIALIZADOR DE NSManagedObject
         Necesitamos llamar a nuestro designated initializer para insertar
         una entidad nueva en el contexto
         
         0: entidad
         1: context
         
         */
        self.init(entity: ent.0, insertInto: ent.1)
        
        /**
         Luego parseamos los datos normalmente
         */
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(ComicsData.self, forKey: .data)
    }
    
}

class ComicsData: NSManagedObject, Decodable {
    
    @NSManaged var total: Int32
    @NSManaged var count: Int32
    @NSManaged var results: Set<Comic>
    
    enum CodingKeys: String, CodingKey {
        case total
        case count
        case results
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        guard let ent = ComicsResponse.hasValidContext(decoder: decoder, entityName: "ComicsData") else {
            fatalError("Failed to decode Subject!")
        }
        
        //INICIALIZADOR DE NSManagedObject
        self.init(entity: ent.0, insertInto: ent.1)
        
        //PARSEO DE DATOS
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int32.self, forKey: .total)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.results = try container.decode(Set<Comic>.self, forKey: .results)
    }
}

class Comic: NSManagedObject, Decodable{
    
    @NSManaged var id: Int32
    @NSManaged var comicDescription: String?
    @NSManaged var thumbnail: Thumbnail
    @NSManaged var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case comicDescription = "description"
        case thumbnail
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let ent = ComicsResponse.hasValidContext(decoder: decoder, entityName: "Comic") else {
            fatalError("Failed to decode Subject!")
        }
        
        self.init(entity: ent.0, insertInto: ent.1)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.comicDescription = try container.decode(Optional.self, forKey: .comicDescription)
        self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
   
        //self.urls = try container.decode(Set<URLs>.self, forKey: .urls)
   
    }
    
    
    /*init(id: Int, description: String, image: String?, title: String?){
        
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        
    }*/
    
}

