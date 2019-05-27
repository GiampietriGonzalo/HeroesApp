import UIKit

class ListComicsViewController: UIViewController{

    @IBOutlet weak var comicsList: UICollectionView!
    @IBOutlet var myView: UIView!
    
    private var comicModel : ListComicsViewModelProtocol?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        comicModel = ListComicsViewModel()
        lookForComics()
    }
    

    private func lookForComics(){
        comicModel?.lookForComics(){ [weak self] in
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
        return comicModel!.getComicsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = comicsList.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        comicModel?.initComicCell(cell: myCell, row: indexPath.row)
        return myCell
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier else{ return }
        
        if (segueId == "comicDetailSegue"){
            guard let myCell = sender as? ComicCollectionCell ,let index = comicsList.indexPath(for: myCell)?.row else {
                return
            }
            let myVC = segue.destination as? ComicDetailsViewController
            myVC?.comic = comicModel?.getComicAt(index: index)
        }
    }
}

