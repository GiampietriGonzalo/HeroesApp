//
//  Hero.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/02/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import CoreData

/*
 Definir un struct Heroe que va a contener
 - Un identificar o id de tipo entero
 - Un nombre de tipo string que puede ser opcional
 - Una descripción de tipo string que puede ser opcional
 - Y una image. Por el momento va a ser un string
 */


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



/**
 Necesitamos definir una CodingUserInfoKey nueva para poder guardar nuestro context en el decoder.
 Entonces declaramos una extension de CodingUserInfoKey y una key nueva estatica
 */
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
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

/*---------------------------------------------------------------------------------------------------------------*/
//DEFINICIONES PARA COREDATA


enum URLType: String, Decodable {
    case wiki
    case detail
    case comiclink
    
}

class HeroesResponse: NSManagedObject, CodableHasContextChecker, Decodable {
    
    
    @NSManaged var data: HeroesData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let ent = HeroesResponse.hasValidContext(decoder: decoder, entityName: "HeroesResponse") else {
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
        self.data = try container.decode(HeroesData.self, forKey: .data)
    }
    
}


class HeroesData: NSManagedObject, Decodable {
    
    @NSManaged var total: Int32
    @NSManaged var count: Int32
    @NSManaged var results: Set<Hero>
    
    enum CodingKeys: String, CodingKey {
        case total
        case count
        case results
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        guard let ent = HeroesResponse.hasValidContext(decoder: decoder, entityName: "HeroesData") else {
            fatalError("Failed to decode Subject!")
        }
        
        //INICIALIZADOR DE NSManagedObject
        self.init(entity: ent.0, insertInto: ent.1)
        
        //PARSEO DE DATOS
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int32.self, forKey: .total)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.results = try container.decode(Set<Hero>.self, forKey: .results)
    }
}



class Hero: NSManagedObject,Decodable{
    
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
            let entity = NSEntityDescription.entity(forEntityName: "Thumbnail", in: managedObjectContext) else {
                fatalError("Failed to decode Subject!")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        /**
         Type lo parseamos como un string porque es el tipo de dato que tiene CoreData y el
         tipo de dato en el JSON
         */
        self.path = try container.decode(String.self, forKey: .path)
        self.theExtension = try container.decode(String.self, forKey: .theExtension)
    }
    
    
    
    func completePath() -> String? {
        guard let validPath = self.path, let validExtension = self.theExtension else {
            return nil
        }
        return validPath + "." + validExtension
    }
}

    

    
class URLs: NSManagedObject, Decodable {
    /**
     CoreData no tiene tipo de dato "enum", entonces tenemos que parsear el valor del enum
     y luego generar un enum con dicho valor.
     
     Como no queremos usar esta property mas que para almacenar el valor del modelo de CoreData,
     la declaramos como privada
     */
    @NSManaged private var type: String
    @NSManaged var url: String
    
    /**
     Este es el valor veradero que queremos exponer de esta clase. Queremos que el type en
     vez de ser usado como un string, sea usado como un enum. Para eso, declaramos
     una propiedad readonly que devuelve el valor de type convertido a un enum
     */
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
            let entity = NSEntityDescription.entity(forEntityName: "URLs", in: managedObjectContext) else {
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

/*---------------------------------------------------------------------------------------------------------------*/

//DEFINICONES PARA EL DECODE LAS RESPONSE DE LA API





/*struct ComicListReponse: Decodable {
 internal struct ComicResponseData: Decodable {
 let total: Int?
 let count: Int?
 let results: [Comic]?
 }
 let data: ComicResponseData!
 }*/

/*struct CreatorListReponse: Decodable {
 internal struct CreatorResponseData: Decodable {
 let total: Int?
 let count: Int?
 let results: [Creator]?
 }
 let data: CreatorResponseData!
 }*/
/*struct ComicResponse: Decodable {
 let available: Int?
 let collectionURI: String?
 
 }*/


/*struct Creator: Decodable{
 let id: Int?
 let firstName: String?
 let middleName: String?
 let fullName: String?
 let thumbnail: Thumbnail?
 }*/
