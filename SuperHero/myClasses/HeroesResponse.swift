import Foundation
import CoreData

class HeroesResponse: NSManagedObject, CodableHasContextChecker, Decodable {
    
    @NSManaged var data: HeroesData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let ent = HeroesResponse.hasValidContext(decoder: decoder, entityName: "HeroesResponse") else {
            fatalError("Failed to decode Subject!")
        }
        
        
        self.init(entity: ent.0, insertInto: ent.1)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(HeroesData.self, forKey: .data)
    }
    
}
