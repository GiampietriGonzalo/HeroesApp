import Foundation
import SwiftyJSON
import UIKit
import CoreData

class MarvelAPIClient: HeroesDataProvider{
 
    private var urlRequest: URL?
    private var urlSession : URLSession?
    private var dataTask : URLSessionDataTask?
    private var myHeroes: Set<Hero>?
    private var parser: Parser
    typealias serviceResponse = (Set<Hero>?) -> Void
    
    init(){
        //TODO Dependecy Injection para PARSER y CoreDataManager
        parser = ParserImp()
    }

    func getSuperheroes(completion: @escaping CompletionAlias.HeroesRequestCompletion){
        var heroResponse: HeroesResponse?
        var heroesFound = [Hero]()
        
        urlRequest = URL(string: Constants.MARVEL_HEROES_URL)!
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(
            with: urlRequest!,
            completionHandler: { [weak self] (data, response, error) in
                
                if let error = error {
                    self?.showRequestError(error: error)
                } else if let self = self, let data = data{
                    heroResponse = self.parser.parse(this: data, type: HeroesResponse.self, at: 0)
                }

                for hero in heroResponse?.data.results ?? []{
                    heroesFound.append(hero)
                }
                completion(heroesFound)
        })
        dataTask?.resume()
    }
    
    func getComicsOfHero(heroID: Int32, completion: @escaping CompletionAlias.ComicsRequestCompletion){
        var comics = [Comic]()
        var comicsFromResponse: ComicsResponse?
        
        urlSession = URLSession(configuration: .default)
        urlRequest = URL(string: Constants.marvelHeroComicsUrl(heroID: heroID))
        
        dataTask = urlSession?.dataTask(
            with: urlRequest!,
            completionHandler: { [weak self](data,response,error) in
                
                if let error = error {
                    self?.showRequestError(error: error)
                } else if let self = self, let data = data{
                    comicsFromResponse = self.parser.parse(this: data, type: ComicsResponse.self, at: 1)
                    for comic in comicsFromResponse?.data.results ?? []{
                        comics.append(comic)
                    }
                }
                completion(comics)
        })
        dataTask?.resume()
    }
    
    func getComics(completion: @escaping CompletionAlias.ComicsRequestCompletion){
        var comics = [Comic]()
        var comicsResponse: ComicsResponse?
        
        urlRequest = URL(string: Constants.MARVEL_COMICS_URL)
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(
            with: urlRequest!,
            completionHandler:{ [weak self](data,response,error) in
            
                if let error = error {
                    self?.showRequestError(error: error)
                } else if let self = self, let data = data{
                    comicsResponse = self.parser.parse(this: data, type: ComicsResponse.self, at: 2)
                    for comic in comicsResponse?.data.results ?? []{
                        comics.append(comic)
                    }
                }
                completion(comics)
        })
        dataTask?.resume()
    }
    
    func getWikiOfHero(heroName: String, completion: @escaping CompletionAlias.WikiRequestCompletion){
        var heroResponse : HeroesResponse?
        var returnedHero: Hero?
        var wikiURL: String?
        
        urlSession = URLSession(configuration: .default)
        urlRequest = URL(string: Constants.marvelHeroByNameUrl(name: heroName))
        
        dataTask = urlSession?.dataTask(
            with: urlRequest!,
            completionHandler: { [weak self] (data,response,error) in
                
                if let error = error {
                    self?.showRequestError(error: error)
                } else if let self = self, let data = data{
                    heroResponse = self.parser.parse(this: data, type: HeroesResponse.self, at: 3)
                    returnedHero = heroResponse?.data.results.first
                    wikiURL = self.setWikiUrlFromNotification(urls: returnedHero?.urls ?? [])
                }
                completion(wikiURL)
        })
        dataTask?.resume()
    }
    
    private func setWikiUrlFromNotification(urls: Set<URLs>) -> String {
        var wikiURL : String?
        for url in urls {
            if url.realType == .wiki {
                wikiURL = url.url
            }
        }
        return wikiURL ?? "URL NOT FOUND"
    }
    
    func getHeroByID(heroID: Int32,completion: @escaping CompletionAlias.HeroRequestCompletion){
        var heroFound: Hero?
        var heroesResponse: HeroesResponse?
        
        urlRequest = URL(string: Constants.marveloHeroByIDUrl(heroID: heroID))
        urlSession = URLSession(configuration: .default)
        
        dataTask = urlSession?.dataTask(
            with: urlRequest!,
            completionHandler: { [weak self] (data,response,error) in
                
                if let error = error {
                    self?.showRequestError(error: error)
                } else if let self = self, let data = data{
                    heroesResponse = self.parser.parse(this: data, type: HeroesResponse.self, at: 5)
                    heroFound = heroesResponse?.data.results.first
                }
                completion(heroFound)
                
        })
        dataTask?.resume()
    }
}

extension MarvelAPIClient {
    private func showRequestError(error: Error){
        print(Messages.REQUEST_ERROR_MESSAGE)
    }
}

