//
//  SuperheroManager.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 07/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SuperheroManager {
 
    private var superheroes: [Hero] = []
    private let myClient: APIClient
    private typealias serviceResponse = ([Hero]?, Error?) -> Void

    init(){
        myClient = APIClient()
    }
    
    /*
     Filtro de superheroes para la API. Nunca lo usé D:
     */
    func searchSuperheroes(namedWith: String, completion: ([Hero],Bool,String) -> Void) {
        
        let mySearchArray = superheroes.filter {
            $0.name.contains(namedWith)
        }
        
        if (!mySearchArray.isEmpty) {
            
            completion(mySearchArray, true,"")
        
        }
        else{
            completion([],false,"Superheroe/s no encontrado/s")
        }
    }
    
    /*
     Callback para pedir los datos a la API desde la clases APIClient
     En caso exitoso, completion returna el arrego de superheroes.
     Caso contrario, el se imprime el error por consola.
     */
    func getSuperheroesFromAPI(completion: @escaping ([Hero]) -> Void) {
        
        myClient.getSuperheroes{ (heroesSet,error) in
            
            
            guard let myHeroes = heroesSet else {
                return
            }
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            else{
                
                for hero in myHeroes{
                    self.superheroes.append(hero)
                }
    
                completion(self.superheroes)
            }
        }
    }
    
    //agregar completion
    func getComicsFromHero(heroID: Int32, completion: @escaping ([Comic]?) -> Void){
        myClient.getComicsHero(heroID: heroID ) { (heroComics,error) in
            
            if let error = error{
                print("Error en la request de los comics por ID\n\(error.localizedDescription)")
            }
           completion(heroComics)
        }
    }
    
    //TODO 
    func getComics(completion: @escaping ([Comic]?) -> Void) {
        
        myClient.getComics() { (heroComics,error) in
            
            if let error = error{
                print("Error en la request de los comics de los comics :  \n \(error.localizedDescription)")
            }
        
            completion(heroComics)
     
        }
        
        
    }
    
    func getwikiHero(hero:Hero,  completion: @escaping (String?) -> Void){
        
        myClient.getWiki(hero: hero){ (wikiUrl,error) in
            
            if error != nil{
                print("Error en la request de la wiki :  \n \(error!.localizedDescription)")
            }
            
            completion(wikiUrl)

        }
    }
    
    func getHeroByID(heroID: Int32, completion: @escaping (Hero) -> Void){
        
        myClient.searchHerobyID(heroID: heroID){ hero in
            
            guard let myHero = hero else{
                return
            }

            completion(myHero)
        }
    }



}
