//
//  AppDelegate.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/02/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coreDataManager : PersistenceGateway?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.coreDataManager = CoreDataPersistence()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){ (result,error) in
            error != nil ? print("Error at authorization") : print("Authorization Succesfull")
        }
        
        UNUserNotificationCenter.current().delegate = self;
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
      
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /**
     Muestra la notificación
     */
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        UNUserNotificationCenter.current().delegate = self
        completionHandler([.alert,.sound, .badge])
    }
    

    /**
     Llegó una notificación -> se manda al usuario al detalle del superheroe previamente seleccionado
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notificationInfo : [AnyHashable : Any]
        var heroID : Int32?
        var tabViewController: UITabBarController?
        var rootViewController : UINavigationController?
        var mainStoryboard: UIStoryboard?
        var detailController: DetailViewController?
        var detailViewModel : HeroDetailViewModel?
        
        if response.notification.request.identifier == "reminderNotification" {

            notificationInfo = response.notification.request.content.userInfo
            heroID = notificationInfo["heroID"] as? Int32
            detailViewModel = HeroDetailViewModel(heroID: heroID ?? 0)
            
            //REALIZAR CONSULTA PARA BUSCAR EL HERO POR ID
            
            //Tomo el tabController principal
            tabViewController = self.window!.rootViewController as? UITabBarController
            
            //Tomo a RootViewControlller, el cual es el primero en arreglo del tabController
            rootViewController = tabViewController?.viewControllers?[0] as? UINavigationController
            
            //Levanta el main storyboard
            mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            //Levanta el DetailViewController
            detailController = mainStoryboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            
            detailController?.heroViewModel = detailViewModel
            //detailController?.paintData()
        
            //Pusheo al DetailViewController
            rootViewController?.pushViewController(detailController!, animated: true)
            tabViewController?.selectedIndex = 0
            
            completionHandler()
        }
    }
}




