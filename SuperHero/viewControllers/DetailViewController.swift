import UIKit
import AVKit
import Alamofire
import SDWebImage

class DetailViewController: UIViewController, UICollectionViewDataSource {

    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroId: UILabel!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var comicsCollection: UICollectionView!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    
    var heroModelView: HeroModelViewProtocol?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.wikiButton.isHidden = true

        paintAll()
        
       
    }
    
    private func paintAll(){
        
        paintBorder()
        paintData()
        lookForWiki()
        
    }
    
    private func lookForWiki(){
        
        heroModelView?.lookForWiki { [weak self] (urlGiven) in
            
            guard let mySelf = self else {
                return
            }
            
            
            if let url = urlGiven, url != "" {
                DispatchQueue.main.sync {
                    mySelf.wikiButton.isHidden = false
                }
            }
        }
        
        
    }
    
    private func paintBorder(){
        
        heroImage.layer.borderWidth = 3.0
        heroImage.layer.borderColor = UIColor.white.cgColor
        heroImage.clipsToBounds = true
    
    }
    
    private func paintData(){
        
        heroId.text = "ID: \(heroModelView?.getHeroID() ?? 0000 )"
        
        heroImage!.sd_setImage(with: URL(string: heroModelView?.getHeroUrlImage() ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        heroName.text = heroModelView?.getHeroName()
        
        heroDescription.text = "DESCRIPTION\n\(heroModelView?.getHeroDescription() ?? "") "
        
        lookForComics()
        
    }
    
    private func lookForComics() {
        
        heroModelView?.lookForComics { [weak self] in
            
            guard let mySelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                mySelf.comicsCollection.reloadData()
            }
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier else{
            return
        }
        
        
        //Zoomea la imagen del heroe
        if(segueId == "tapSegue"){
            let myVC = segue.destination as? HeroImageZoomViewController
            myVC?.heroImage = heroModelView?.getHeroUrlImage()
        }
        
        
        //Va al detalle del comic seleccionado
        if (segueId == "comicSegue"){
            
            guard let myCell = sender as? ComicCollectionCell ,let index = comicsCollection.indexPath(for: myCell)?.row else {
                return
            }
            
            let myVC = segue.destination as? ComicViewController
            myVC?.comic = heroModelView?.getComicAt(index: index)
        
            
        }
        
        //Abre la wiki del heroe
        if (segueId == "heroWikiSegue"){
            
            let myVC = segue.destination as? WikiWebViewController
            myVC?.wikiWeb = heroModelView?.getUrlWiki()
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroModelView?.getComicsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        
      
        myCell.comicImage.sd_setImage(with: URL(string: heroModelView!.getHeroUrlImage()),  placeholderImage: nil, options: [], completed: nil)
      
        
        return myCell
    }
    
   
    /* Accion para ver video trailer; ya no lo uso
   @IBAction func watchVideo(_ sender: UIButton) {
        
        
        guard let path = Bundle.main.path(forResource: "tr1", ofType:"mp4") else {
            print("Trailer not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let vc = AVPlayerViewController()
        vc.player = player
        vc.view.alpha = 0.5

    
        present(vc, animated: true) {
            //vc.player?.play()
        }
        
    }
*/
    
}
