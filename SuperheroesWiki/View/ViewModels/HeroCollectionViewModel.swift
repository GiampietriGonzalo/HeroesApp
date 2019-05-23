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
    private var dataProvider: HeroesDataProvider?
    
    init(){
        superheroes = []
        dataProvider = MarvelAPIClient()
        search = []
    }
    
    func lookForHeroes(completion: @escaping CompletionAlias.EmptyCompletion){
        dataProvider?.getSuperheroes{ [weak self] heroes in
            guard let self = self else { return }
            self.superheroes = heroes
            completion()
        }
    }
    
    func getHeroesCount() -> Int {
        return (searching ? search?.count : superheroes?.count) ?? 0
    }
    
    func getHeroes() -> [Hero]? {
       return searching ? search : superheroes
    }
    
    func getHeroUrlImage(atIndex: Int) -> String? {
        return searching ? search?[atIndex].thumbnail.completePath() : superheroes?[atIndex].thumbnail.completePath()
    }
    
    func getHeroName(indexAt: Int) -> String? {
        return (searching ? search?[indexAt].name : superheroes?[indexAt].name) ?? Messages.NAME_NOT_FOUND
    }
    
    func getHero(index: Int) -> Hero? {
        return searching ? search?[index] : superheroes?[index]
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
        content = buildContent()
        content.userInfo = ["heroID": heroAux.id]
        
        date = Date().addingTimeInterval(7.0)
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if let error = error {
                print(Messages.NOTIFICATION_ERROR_MESSAGE + ": \(error)")
            }
        })
    }
    
    private func buildContent() -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = Messages.NOTIFICATION_REMINDER_TITLE
        content.subtitle = Messages.NOTIFICATION_REMINDER_SUBTITLE
        content.body = Messages.NOTIFICATION_REMINDER_BODY
        content.sound = UNNotificationSound.default
        return content
    }
}
