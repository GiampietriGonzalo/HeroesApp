import Foundation
import CoreData

class Thumbnail: NSManagedObject ,Decodable {
    
    @NSManaged var path: String?
    @NSManaged var theExtension: String?
    
    //COMO EXTENSION ES UNA PALABRA RESERVADA EN SWIFT HAY QUE CREAR KEYS Y ASIGNARLE EL VALOR DE ESA VARIABLE
    enum CodingKeys: String, CodingKey {
        case path
        case theExtension = "extension"
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Thumbnail", in: managedObjectContext)
            else {
                fatalError("Failed to decode Subject!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decode(String.self, forKey: .path)
        self.theExtension = try container.decode(String.self, forKey: .theExtension)
    }
    
    func completePath() -> String? {
        guard let validPath = self.path,
            let validExtension = self.theExtension
            else {
            return nil
        }
        return validPath + "." + validExtension
    }
}
