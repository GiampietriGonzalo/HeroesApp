import UIKit
import SDWebImage
import UserNotifications
import CoreData

class HeroCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var heroTable: UITableView!
    private var searching = false
    var heroCollectionModel : HeroCollectionViewModel?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        heroCollectionModel = HeroCollectionViewModel()
        lookForHeroes()
   
    }
    
    private func lookForHeroes(){
        
        heroCollectionModel?.lookForHeroes(){ [weak self] in
            
            guard let mySelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                mySelf.heroTable.reloadData()
            }
        }
    }
    
    //MARK : SEGUE
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier, let celda = sender as? HeroCell, let index = heroTable.indexPath(for: celda) else {
            return
        }
        
        let myVC = segue.destination as! DetailViewController
        
        if(id == "detailSegue"){
            
            myVC.heroModelView = HeroDetailViewModel(hero: heroCollectionModel?.getHero(index: index.row) ?? nil)
        }
    }
    
    //MARK : TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroCollectionModel?.getHeroesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 75.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = heroTable.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! HeroCell
      
        paintHeroCell(cell: cell, row: indexPath.row)
        
        return cell
       
    }
    
    private func paintHeroCell(cell: HeroCell, row: Int){
        
        let urlImage = heroCollectionModel?.getHeroUrlImage(atIndex: row)
        
        cell.heroimg.sd_setImage(with: URL(string: urlImage ?? ""),  placeholderImage: nil, options: [], completed: nil)
        
        cell.heroName.text =  heroCollectionModel?.getHeroName(indexAt: row)
        cell.notificationButton.tag = row
    }
    
    @IBAction func addSeeLaterNotification(_ sender: Any) {
        
        heroCollectionModel?.addNotificaciont(tag: (sender as! UIButton).tag)
    
        let seeLaterButton = sender as! UIButton
      
        heroCollectionModel?.addNotificaciont(tag: seeLaterButton.tag)
        
        seeLaterButton.isHidden = true
    }
}

//SearchBar behavior
extension HeroCollectionViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        heroCollectionModel?.searchLogic(searchText: searchText){ [weak self] in
            
            guard let mySelf = self else{
                return
            }
            
            DispatchQueue.main.async {
                mySelf.heroTable.reloadData()
            }
        }
    }
    
    //CancelButton - SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        heroTable.reloadData()
        searchBar.text = ""
    }
}
