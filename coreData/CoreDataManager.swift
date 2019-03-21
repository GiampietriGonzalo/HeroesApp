import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    private let appDelegate : AppDelegate?
    private let context : NSManagedObjectContext?
    
    init(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    /**
     Si queremos storear a mano un HeroesResponse. Esto es a modo ilustrativo, ya que
     un HeroessResponse con datos cargados nos lo provee la API.. en este caso nos va a guardar
     un HeroessResponse sin datos a menos que se los seteemos manuelmente dato por dato
     */
    func store(/*contex: NSManagedObjectContext*/) {
        
        //let Heroes = HeroesResponse(context: contex)
        
        do {
            try context?.save()
            print("STORE EXITOSO!")
        }
        catch let error {
            print("FALLO EL STORE :: \(error)")
        }
    }
    
    /**
     Ejecuta una query para obtener una lista de objetos HeroessResponse que tengamos almacenada
     en nuestra base.
     */
    func fetch() {
        
        let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
        
        do {
            let results = try context?.fetch(fetchRequest)
            
            print("FUNCIONO FETCH :: \(results!.count)")
            
            
        }
        catch let error {
            print("FALLO EL FETCH :: \(error)")
        }
        
    }
    
    /**
     Para hacer update primero hacemos un fetch como para obtener los objetos que vamos a updatear,
     en este ejemplo, agarramos el primer Heroes y le cambiamos el nombre
     */
    func update(/*context: NSManagedObjectContext*/) {
        
        //let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
        
        do {
            //let results = try context.fetch(fetchRequest)
            //let firstHeroes = results.first!.data.results.first!
            
            
            try context?.save()
            print("UPDATE :: Sucessfull")
            
        }
        catch let error {
            print("FALLO EL UPDATE :: \(error)!")
        }
    }
    
    /**
     En este caso, hacemos un fetch para obtener todos los objetos HeroessResponse que tengamos almacenados
     en la base. Dependiendo del valor del booleano, va a borrar el primero o todos
     */
    func delete(/*contex: NSManagedObjectContext*/ onlyFirstValue: Bool) {
        
        do {
            if onlyFirstValue {
                let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
                let results = try context?.fetch(fetchRequest)
                if let aFirst = results?.first {
                    context?.delete(aFirst)
                }
            }
            else {
                let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
                let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                try context?.execute(batchDelete)
                print("DELETE :: SUCESSFULL")
            }
        }
        catch let error {
            print("FALLO EL DELETE! :: \(error)")
        }
    }
    
    func saveContext () {
        
        guard let myContext = context else {
            return
        }
        
        if myContext.hasChanges {
            do {
                try myContext.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}
