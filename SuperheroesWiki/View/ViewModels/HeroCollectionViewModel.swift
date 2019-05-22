//
//  HeroCollectionViewModel.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 22/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import UserNotifications
import CoreData

class HeroCollectionViewModel: HeroCollectionViewModelProtocol {
    
    private var search: [Hero]? = []
    private var searching = false
    private var superheroes: [Hero]?
    private var manager: SuperheroManager?
    
    init(){
        superheroes = []
        manager = SuperheroManager()
        search = []
    }
    
    func lookForHeroes(completion: @escaping () -> ()){
        manager?.getSuperheroesFromAPI{ [weak self] heroes in
            guard let mySelf = self else { return }
            mySelf.superheroes = heroes
            completion()
        }
    }
    
    func getHeroesCount() -> Int {
        if searching {
            return search?.count ?? 0
        }
        return superheroes?.count ?? 0
    }
    
    func getHeroesCollection() -> [Hero]? {
        var toReturn : [Hero]?
        
        if searching{
            toReturn = search
        } else {
            toReturn = superheroes
        }
        return toReturn
    }
    
    func getHeroUrlImage(atIndex: Int) -> String? {
        var url : String?
        
        if searching{
            url = search?[atIndex].thumbnail.completePath()
        } else {
            url = superheroes?[atIndex].thumbnail.completePath()
        }
        return url
    }
    
    func getHeroName(indexAt: Int) -> String? {
        var name : String?
        
        if searching {
            name = search?[indexAt].name
        } else {
            name = superheroes?[indexAt].name
        }
        return name ?? "ERROR 404: NAME NOT FOUND"
    }
    
    func getHero(index: Int) -> Hero? {
        
        var heroToReturn: Hero?
        
        if(searching){
            heroToReturn = search?[index]
        }
        else{
            heroToReturn = superheroes?[index]
        }
        
        return heroToReturn
    }
    
    func searchLogic(searchText: String, completion: @escaping () -> ()){
        guard let sup = superheroes else { return }
        
        if(searchText == ""){
            search = sup
        } else {
            search = []
            for h in sup{
                if (h.name.contains(searchText)) {
                    search = sup.filter({$0.name.prefix(searchText.count) == searchText })           
                }
            }
        }
        searching = true
        completion()
    }
    
    func addNotificaciont(tag: Int){

        let center = UNUserNotificationCenter.current()
        let content: UNMutableNotificationContent
        var request : UNNotificationRequest
        var trigger : UNCalendarNotificationTrigger
        var dateComponents: DateComponents
        var heroAux : Hero
        var date : Date
        
        center.requestAuthorization(options: [.badge,.alert,.sound]){ (success,error) in
            guard error != nil else { return }
        }
        
        heroAux = getHero(index: tag)!
        //Paso el hero por userInfo del notifiaction
        content = buildContent()
        content.userInfo = ["heroID": heroAux.id]
        
        date = Date().addingTimeInterval(7.0)
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if let myError = error {
                print("Error de notification:\n\(myError.localizedDescription)")
            }
        })
      
    }
    
    private func buildContent() -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.subtitle = "You MUST see this!"
        content.body = "You must see the awesome superhero wiki ;)"
        content.sound = UNNotificationSound.default
        return content
    }
}
