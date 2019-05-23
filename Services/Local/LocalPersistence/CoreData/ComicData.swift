import Foundation
import CoreData

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
