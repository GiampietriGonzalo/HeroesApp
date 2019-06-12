import UIKit

class ListComicsViewController: UIViewController, ListComicsViewControllerProtocol{

    @IBOutlet weak var comicsList: UICollectionView!
    var router: ListComicsRouterProtocol?
    var interactor : ListComicsInteractor?

    override func awakeFromNib(){
        super.awakeFromNib()
        ListComicsConfigurator.configure(controller: self, with: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookForComics()
    }
    
    private func lookForComics(){
        interactor?.lookForComics(){ [weak self] in
            guard let mySelf = self else{ return }
            mySelf.performSelector(onMainThread: #selector(mySelf.reloadComicCollectionData), with: nil, waitUntilDone: true)
        }
    }
    
    @objc private func reloadComicCollectionData(){
        comicsList.reloadData()
    }
}

extension ListComicsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor!.getComicsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = comicsList.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        interactor?.initComicCell(cell: myCell, row: indexPath.row)
        return myCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myCell = sender as? ComicCollectionCell,
            let index = comicsList.indexPath(for: myCell)?.row,
            let interactor = interactor {
            let output = ListComicsOutput(comic: interactor.getComicAt(index: index)!)
            router?.goToController(with: segue, withData: output)
        }
    }
}

