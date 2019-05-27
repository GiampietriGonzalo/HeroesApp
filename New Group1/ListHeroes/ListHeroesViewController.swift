import UIKit
import SDWebImage
import UserNotifications
import CoreData

class ListHeroesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var heroTable: UITableView!
    private var searching = false
    private var heroesListModel : ListHeroesViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroesListModel = ListHeroesViewModel()
        lookForHeroes()
    }
    
    private func lookForHeroes(){
        heroesListModel?.lookForHeroes(){ [weak self] in
            guard let mySelf = self else { return }
            mySelf.performSelector(onMainThread: #selector(mySelf.reloadHeroTableData), with: nil, waitUntilDone: true)
        }
    }
    
    @objc private func reloadHeroTableData(){
        heroTable.reloadData()
    }
    
    //MARK : SEGUE
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, let celda = sender as? HeroCell, let index = heroTable.indexPath(for: celda) else {
            return
        }
        
        let myVC = segue.destination as! DetailViewController
        if(id == "detailSegue"){
            myVC.heroViewModel = HeroDetailViewModel(hero: heroesListModel?.getHero(index: index.row) ?? nil)
        }
    }
    
    //MARK : TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesListModel?.getHeroesCount() ?? 0
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
        let urlImage = heroesListModel?.getHeroUrlImage(atIndex: row)
        cell.heroimg.sd_setImage(with: URL(string: urlImage ?? ""),  placeholderImage: nil, options: [], completed: nil)
        cell.heroName.text =  heroesListModel?.getHeroName(indexAt: row)
        cell.notificationButton.tag = row
    }
    
    @IBAction func addSeeLaterNotification(_ sender: Any) {
        let seeLaterButton = sender as! UIButton
        heroesListModel?.addNotificaciont(tag: (sender as! UIButton).tag)
        heroesListModel?.addNotificaciont(tag: seeLaterButton.tag)
        seeLaterButton.isHidden = true
    }
}

extension ListHeroesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        heroesListModel?.searchLogic(searchText: searchText){ [weak self] in
            guard let mySelf = self else{ return }
            mySelf.performSelector(onMainThread: #selector(mySelf.reloadHeroTableData), with: nil, waitUntilDone: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        heroTable.reloadData()
        searchBar.text = ""
    }
}
