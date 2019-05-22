//
//  Comic.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 01/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import CoreData

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
    }

}

