import Foundation
import CoreData

class Hero: NSManagedObject, Source{
    
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var heroDescription: String?
    @NSManaged var thumbnail: Thumbnail
    @NSManaged var urls: Set<URLs>
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case heroDescription = "description"
        case thumbnail
        case urls
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let ent = HeroesResponse.hasValidContext(decoder: decoder, entityName: "Hero") else {
            fatalError("Failed to decode Subject!")
        }
        //INICIALIZADOR DEL SNManagedObject
        self.init(entity: ent.0, insertInto: ent.1)
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.heroDescription = try container.decode(Optional.self, forKey: .heroDescription)
        self.thumbnail = try container.decode(Thumbnail.self
            , forKey: .thumbnail)
        self.urls = try container.decode(Set<URLs>.self, forKey: .urls)
    }
}

enum WikiType: String, Decodable {
    case wiki
    case detail
    case comiclink
}

struct Url: Decodable{
    let type: WikiType?
    let url: String?
}


    

    

