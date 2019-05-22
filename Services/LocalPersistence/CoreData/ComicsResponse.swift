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
        self.init(entity: ent.0, insertInto: ent.1)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(ComicsData.self, forKey: .data)
    }
    
}
