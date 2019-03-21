import Foundation
import CoreData

/**
 Definimos un protocolo para tener la validacion del context en un solo lugar y poder
 reutilizarla en todos nuestros modelos
 */
protocol CodableHasContextChecker {
    
    /**
     Necesitamos pasarle el decoder y el nombre de la entidad que vamos a buscar en el Model de CoreData
     Devuelve una tupla con la entidad y el contexto
     */
    static func hasValidContext(decoder: Decoder, entityName: String) -> (NSEntityDescription, NSManagedObjectContext)?
}

extension CodableHasContextChecker {
    
    static func hasValidContext(decoder: Decoder, entityName: String) -> (NSEntityDescription, NSManagedObjectContext)? {
        /*
         Obtenemos la key que definimos. Esto es un optional y hay que unwrappearlo porque
         internamente es un enum, y los enum pueden fallar al inicializarse
         */
        guard let contextUserInfoKey = CodingUserInfoKey.context else {
            return nil
        }
        
        /**
         Una vez que tenemos la key, pedimos el context que pasamos por referencia al decoder
         */
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            return nil
        }
        
        /**
         Ya con la key y el context podemos buscar la entidad en el Modelo de CoreData
         */
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {
            return nil
        }
        
        /**
         Si todo salio bien, devolvemos la entidad y el context
         */
        return (entity, managedObjectContext)
    }
}
