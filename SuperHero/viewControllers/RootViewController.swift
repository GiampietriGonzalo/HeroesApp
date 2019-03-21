//
//  HeroViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 27/02/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit
import SDWebImage
import UserNotifications
import CoreData

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var heroTable: UITableView!
    
    private var search: [Hero]? = []
    private var searching = false
    private var superheroes: [Hero]?
    private var manager: SuperheroManager?
    private var urlSession: URLSession!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        superheroes = []
        manager = SuperheroManager()
        lookForHeroes()
        
    }
    
    private func lookForHeroes(){
        
        manager?.getSuperheroesFromAPI{ [weak self] heroes in
            
            guard let mySelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                
                mySelf.superheroes = heroes
                mySelf.heroTable.reloadData()
            }
        }
    }
    
    /**
     Si queremos storear a mano un HeroesResponse. Esto es a modo ilustrativo, ya que
     un HeroessResponse con datos cargados nos lo provee la API.. en este caso nos va a guardar
     un HeroessResponse sin datos a menos que se los seteemos manuelmente dato por dato
     */
    func store(contex: NSManagedObjectContext) {
        
        //let Heroes = HeroesResponse(context: contex)
        
        do {
            try contex.save()
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
    func fetch(context: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            print("CANTIDAD DEL CHARs :: \(results.count)")
            
            
        }
        catch let error {
            print("FALLO EL FETCH :: \(error)")
        }
        
    }
    
    /**
     Para hacer update primero hacemos un fetch como para obtener los objetos que vamos a updatear,
     en este ejemplo, agarramos el primer Heroes y le cambiamos el nombre
     */
    func update(context: NSManagedObjectContext) {
       
        //let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
        
        do {
            //let results = try context.fetch(fetchRequest)
            //let firstHeroes = results.first!.data.results.first!

            
            try context.save()
            print("UPDATE: Sucessfull")
            
        }
        catch let error {
            print("FALLO EL UPDATE :: \(error)!")
        }
    }
    
    /**
     En este caso, hacemos un fetch para obtener todos los objetos HeroessResponse que tengamos almacenados
     en la base. Dependiendo del valor del booleano, va a borrar el primero o todos
     */
    func delete(context: NSManagedObjectContext, onlyFirstValue: Bool) {
        
        do {
            if onlyFirstValue {
                let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
                let results = try context.fetch(fetchRequest)
                if let aFirst = results.first {
                    context.delete(aFirst)
                }
            }
            else {
                let fetchRequest = NSFetchRequest<HeroesResponse>(entityName: "HeroesResponse")
                let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                try context.execute(batchDelete)
            }
        }
        catch let error {
            print("FALLO EL DELETE! :: \(error)")
        }
    }
    
    
    
    //MARK : SEGUE
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier, let celda = sender as? HeroCell, let index = heroTable.indexPath(for: celda) else {
            return
        }
        
        let myVC = segue.destination as! DetailViewController
        
        if(id == "detailSegue"){
            
            
            if(searching){
                myVC.myHero = search?[index.row]
            }
            else{
                myVC.myHero = superheroes?[index.row]
            }
        }
        
 
       
    }
    
    //MARK : TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sp = superheroes, let spSearch = search else{
            return 0
        }
        
        if searching {
            return spSearch.count
        }
        
        return sp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 75.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = heroTable.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! HeroCell
        initCustomHeroCell(cell: cell, row: indexPath.row)
            
        return cell
       
    }
    
    
    private func initCustomHeroCell(cell: HeroCell, row: Int){
    
        if(searching){
           paintHeroCell(cell: cell, heroArray: search, row: row)
        }
        else{
            paintHeroCell(cell: cell, heroArray: superheroes, row: row)
        }
     
    }
    
    private func paintHeroCell(cell: HeroCell,heroArray: [Hero]?,row: Int){
        
        let urlImage = heroArray?[row].thumbnail.completePath()
        cell.heroimg.sd_setImage(with: URL(string: urlImage ?? ""),  placeholderImage: nil, options: [], completed: nil)
        cell.heroName.text =  heroArray?[row].name
        cell.notificationButton.tag = row
    }
    
    /**
     Performs notification button from hero collection.
     Send notification in 7 seconds.
     */
    
    //TODO: enviar la ID del hero al infoUser de la notificacion y hacer todo con eso J3J3 que LINDO COREDATA
    //MARK HERE
    @IBAction func addSeeLaterNotification(_ sender: Any) {
    
        let seeLaterButton = sender as! UIButton
        let center = UNUserNotificationCenter.current()
        let content: UNMutableNotificationContent
        
        var request : UNNotificationRequest
        var trigger : UNCalendarNotificationTrigger
        var dateComponents: DateComponents
        var heroAux : Hero
        var date : Date
        
        center.requestAuthorization(options: [.badge,.alert,.sound]){ (success,error) in
            
            guard error != nil else {
                return
            }
            
        }
        
        heroAux = getHeroFromTable(index: seeLaterButton.tag)!
       
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
        
        seeLaterButton.isHidden = true
    }

    private func buildContent() -> UNMutableNotificationContent{
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.subtitle = "You MUST see this!"
        content.body = "You must see the awesome superhero wiki ;)"
        content.sound = UNNotificationSound.default
        
        return content
        
    }

    private func getHeroFromTable(index: Int) -> Hero? {
        
        var heroToReturn: Hero?
        
        if(searching){
            heroToReturn = search?[index]

        }
        else{
            heroToReturn = superheroes?[index]
        }
        
        return heroToReturn
    }

}


//SearchBar behavior
extension RootViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let sup = superheroes else {
            return
        }
        
        if(searchText == ""){
            search = sup
        }
        else{
        
            search = []
            
            for h in sup{
            
                if (h.name.contains(searchText)) {
                
                    search = sup.filter({$0.name.prefix(searchText.count) == searchText })
                
                }
            }
        }
      
        searching = true
        heroTable.reloadData()
        
    }
    
    //CancelButton - SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        heroTable.reloadData()
        searchBar.text = ""
    }
    
    
    
    
}
