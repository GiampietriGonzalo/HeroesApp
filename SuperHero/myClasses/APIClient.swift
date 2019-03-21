import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import CoreData

//TODO: Hacer Singleton

class APIClient {
    
    private static let marvelUrl = "https://gateway.marvel.com/v1/public/characters?"
    private static let publicKey = "df8dd556fd0c4c6b35436d25cbab6dc8"
    private static let hash = "efb23e10af0852878a59f75d4ecba00f"
    
    private var pathRequest: String
    private var urlRequest: URL?
    private var urlSession : URLSession?
    private var dataTask : URLSessionDataTask?
    private var gotConnection : Bool
    private var coreDataManager : CoreDataManager
    
    private var myHeroes: Set<Hero>?
    typealias serviceResponse = (Set<Hero>?, Error?) -> Void
    
    private let appDelegate : AppDelegate?
    private let context : NSManagedObjectContext?
    private let decoder: JSONDecoder
    
    init(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        pathRequest = ""
        gotConnection = true
        coreDataManager = CoreDataManager()
    }
    
    /*
     Hace la request, si la request es exitosa, se parsen los datos obtenidos y se construye el arreglo de heroes. El completion devuelve el arreglo de heroes.
     Si la request no es exitosa, el completio propaga el error.
     */
    
    func getSuperheroes(completion: @escaping serviceResponse){
        
       
        gotConnection = Connectivity.isConnectedToInternet()
        
        
        if !gotConnection {
            
            
            
        }
        
        //HAY INTERNET
        
        pathRequest = "\(APIClient.marvelUrl)apikey=\(APIClient.publicKey)&hash=\(APIClient.hash)&ts=1&limit=99"
        urlRequest = URL(string: pathRequest)!
     
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            
            guard let validData = data else {
                return
            }
            do {
           
                let heroResponse: HeroesResponse = try self.decoder.decode(HeroesResponse.self, from: validData)
                completion(heroResponse.data.results,nil)

            }
            catch {
                print("ERROR AT getSuperheroes:\n\(error.localizedDescription))")
                completion(Set<Hero>(), error)
            }
         
        })
        
        dataTask?.resume()
        
        completion(myHeroes,nil)
    }
    
    func getComicsHero(heroID: Int32, completion: @escaping ([Comic]?,Error?) -> Void){
    
        pathRequest = "https://gateway.marvel.com:443/v1/public/characters/\(heroID)/comics?apikey=\(APIClient.publicKey)&hash=\(APIClient.hash)&ts=1"
        var comics: [Comic] = []
        urlSession = URLSession(configuration: .default)
        urlRequest = URL(string: pathRequest)
        
        dataTask = urlSession?.dataTask(with: urlRequest!,completionHandler: { (data,response,error) in
            
            guard let dataPosta = data else{
                return
            }
            
            do{
                
                let comicsResponse: ComicsResponse = try self.decoder.decode(ComicsResponse.self, from: dataPosta)
                
                for comic in comicsResponse.data.results{
                    comics.append(comic)
                }
     
                completion(comics,nil)
                
                
            }
            catch{
                print("PARSING ERROR AT getComicsHERO\n\(error.localizedDescription)")
                completion(nil,error)
            }
        })
        
        dataTask?.resume()
    }
    
    
    /*
     Busca los primeros 99 comics de la API
     */
    func getComics(completion: @escaping ([Comic]?,Error?) -> Void ){
        
        
        pathRequest = "https://gateway.marvel.com:443/v1/public/comics?limit=99&apikey=\(APIClient.publicKey)&hash=\(APIClient.hash)&ts=1"
        urlRequest = URL(string: pathRequest)
        var comics: [Comic] = []
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(with: urlRequest!,completionHandler: { (data,response,error) in
            
            guard let dataPosta = data else{
                return
            }
            
            do{
            
                let comicsResponse: ComicsResponse = try self.decoder.decode(ComicsResponse.self, from: dataPosta)
                
                for comic in comicsResponse.data.results{
                    comics.append(comic)
                }
                
                completion(comics,nil)
                
            }
            catch{
                print("PARSING ERROR AT getComics\n\(error.localizedDescription)")
                completion(nil,error)
                
            }
            
            
        })
        
        dataTask?.resume()
    }
    
    /*Retorna la url de la wiki asociada al heroe pasado por parámetro*/
    func getWiki(hero: Hero, completion: @escaping (String?,Error?) -> Void){
        
        pathRequest = "https://gateway.marvel.com:443/v1/public/characters?name=\(hero.name.replacingOccurrences(of:" ", with: "%20"))&apikey=\(APIClient.publicKey)&hash=\(APIClient.hash)&ts=1"
        urlSession = URLSession(configuration: .default)
        urlRequest = URL(string: pathRequest)
        
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        
        var wikiURL: String?
        
        dataTask = urlSession?.dataTask(with: urlRequest! , completionHandler: { (data,response,error) in
            
            guard let dataPosta = data else {
                return
            }
            
            do{
                
                let heroResponse : HeroesResponse = try decoder.decode(HeroesResponse.self, from: dataPosta)
                
                let hero = heroResponse.data.results.first
                
                if let heroNotNil = hero {
                    
                    for url in heroNotNil.urls {
                        
                        if url.realType == .wiki {
                            wikiURL = url.url
                        }
                    }
                }
                
                
                completion(wikiURL,nil)
                
            }
            catch{
                
                print("PARSING ERROR AT GET WIKI FROM HERO\n\(error.localizedDescription)")
                
                completion (nil,error)
            }
        })
        
        dataTask?.resume()
        
    }
    
    func searchHerobyID(heroID: Int32,completion: @escaping (Hero?)->()){
        

        var heroToReturn : Hero?
        pathRequest = "\(APIClient.marvelUrl)id=\(heroID)&apikey=\(APIClient.publicKey)&hash=\(APIClient.hash)&ts=1"
        urlRequest = URL(string: pathRequest)
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            
            guard let validData = data else {
                return
            }
            do {
    
                let heroesResponse: HeroesResponse = try self.decoder.decode(HeroesResponse.self, from: validData)
                
                heroToReturn = heroesResponse.data.results.first
                                completion(heroToReturn)
                
            }
            catch {
                print("ERROR AT searchHeroByID\n \(error.localizedDescription)")
                completion(nil)
            }
            
        })
        
        dataTask?.resume()
    }
    
}
