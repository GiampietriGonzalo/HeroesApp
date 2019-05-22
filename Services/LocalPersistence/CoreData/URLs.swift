import Foundation
import CoreData

enum URLType: String, Decodable {
    case wiki
    case detail
    case comiclink
    
}

class URLs: NSManagedObject, Decodable {
    
    @NSManaged private var type: String
    @NSManaged var url: String
  
    var realType: URLType {
        return URLType(rawValue: self.type)!
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "URLs", in: managedObjectContext)
            else {
                fatalError("Failed to decode Subject!")
        }
    
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        /**
         Type lo parseamos como un string porque es el tipo de dato que tiene CoreData y el
         tipo de dato en el JSON
         */
        self.type = try container.decode(String.self, forKey: .type)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
