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
    @IBOutlet weak var wikiButton: UIBarButtonItem!
    @IBOutlet weak var backImage: UIImageView!

    var heroModelView: HeroDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintAll()
    }
    
    private func paintAll(){
        paintBorder()
        paintData()
    }


    private func paintBorder(){
        
        heroImage.layer.borderWidth = 3.0
        heroImage.layer.borderColor = UIColor.white.cgColor
        heroImage.clipsToBounds = true
    
    }
    
    private func paintData(){

        heroModelView?.lookForHero(){ [weak self] in
            
            guard let mySelf = self else{
                return
            }

            mySelf.performSelector(onMainThread: #selector(mySelf.setLablesData), with: nil, waitUntilDone: true)
            mySelf.heroImage!.sd_setImage(with: URL(string: mySelf.heroModelView?.getHeroUrlImage() ?? ""), placeholderImage: nil, options: [], completed: nil)
        }
        
         lookForComics()
    }
    
    @objc private func setLablesData(){
        
        heroId.text = "ID: \(heroModelView?.getHeroID() ?? 0000 )"
        heroName.text = heroModelView?.getHeroName()
        heroDescription.text = "DESCRIPTION\n\(heroModelView?.getHeroDescription() ?? "") "
        
        disableWikiButton()
    }
    
   private func lookForComics() {
        
        heroModelView?.lookForComics { [weak self] in
            
            guard let mySelf = self else {
                return
            }
            
            mySelf.performSelector(onMainThread: #selector(mySelf.reloadTableViewData), with: nil, waitUntilDone: true)
            mySelf.performSelector(onMainThread: #selector(mySelf.enabledWikiButton), with: true, waitUntilDone: true)
        }
    }
    
    @objc private func reloadTableViewData(){
        comicsCollection.reloadData()
    }
    
    @objc private func disableWikiButton(){
        wikiButton.isEnabled = false
    }
    
    @objc private func enabledWikiButton(){
        wikiButton.isEnabled = true;
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier, let id = SegueId(rawValue: segueId) else{
            return
        }
        
        switch id {
            case .tapImage: zoomHeroImage(segue: segue)
            case .comicDetail: gotToWiki(segue: segue, sender: sender)
            case .heroWiki: goToComicDetail(segue: segue)
        }
    }
    
    private func zoomHeroImage(segue: UIStoryboardSegue){
        let myVC = segue.destination as? HeroImageZoomViewController
        myVC?.heroImage = heroModelView?.getHeroUrlImage()
    }

    private func gotToWiki(segue: UIStoryboardSegue,sender: Any?){
        
        guard let myCell = sender as? ComicCollectionCell ,let index = comicsCollection.indexPath(for: myCell)?.row else {
            return
        }
        
        let myVC = segue.destination as? ComicViewController
        myVC?.comic = heroModelView?.getComicAt(index: index)
    }
    
    private func goToComicDetail(segue: UIStoryboardSegue){
        let myVC = segue.destination as? WikiWebViewController
        myVC?.wikiWeb = heroModelView?.getUrlWiki()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroModelView?.getComicsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        myCell.comicImage.sd_setImage(with: URL(string: heroModelView!.getComicUrlImage(atIndex: indexPath.row)),  placeholderImage: nil, options: [], completed: nil)
      
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
