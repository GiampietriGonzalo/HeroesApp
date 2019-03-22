import UIKit

class ComicCollectionViewController: UIViewController{

    @IBOutlet weak var comicCollection: UICollectionView!
    @IBOutlet var myView: UIView!
    
    private var comicModel : ComicModelViewProtocol?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        comicModel = ComicsCollectionViewModel()
        lookForComics()
    }
    

    private func lookForComics(){
        
        comicModel?.lookForComics(){ [weak self] in
            
            guard let mySelf = self else{
                return
            }
            
            DispatchQueue.main.async {
                mySelf.comicCollection.reloadData()
            }
            
        }
    }
        
    
}

extension ComicCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicModel!.getComicsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = comicCollection.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        
        comicModel?.initComicCell(cell: myCell, row: indexPath.row)
        
        return myCell
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier else{
            return
        }
        
        if (segueId == "comicDetailSegue"){
            
            guard let myCell = sender as? ComicCollectionCell ,let index = comicCollection.indexPath(for: myCell)?.row else {
                return
            }
            
            let myVC = segue.destination as? ComicViewController
            myVC?.comic = comicModel?.getComicAt(index: index)
            
        }
        
    }
    
   
}

