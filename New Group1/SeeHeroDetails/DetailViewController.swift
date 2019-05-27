import UIKit
import AVKit

class DetailViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroId: UILabel!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var comicsCollection: UICollectionView!
    @IBOutlet weak var wikiButton: UIBarButtonItem!
    @IBOutlet weak var backImage: UIImageView!
    var heroViewModel: HeroDetailViewModelProtocol?
    
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
        heroViewModel?.lookForHero(){ [weak self] in
            guard let mySelf = self else{ return }
            
            mySelf.performSelector(onMainThread: #selector(mySelf.setLablesData), with: nil, waitUntilDone: true)
            mySelf.heroImage!.sd_setImage(with: URL(string: mySelf.heroViewModel?.getHeroUrlImage() ?? ""), placeholderImage: nil, options: [], completed: nil)
        }
         lookForComics()
    }
    
    @objc private func setLablesData(){
        heroId.text = "ID: \(heroViewModel?.getHeroID() ?? 0000 )"
        heroName.text = heroViewModel?.getHeroName()
        heroDescription.text = "DESCRIPTION\n\(heroViewModel?.getHeroDescription() ?? "") "
        disableWikiButton()
    }
    
   private func lookForComics() {
        heroViewModel?.lookForComics { [weak self] in
            guard let mySelf = self else { return }
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
        guard let segueId = segue.identifier, let id = SegueId(rawValue: segueId) else{ return }
        switch id {
        case .tapImage: zoomHeroImage(segue: segue)
        case .comicDetail: gotToWiki(segue: segue, sender: sender)
        case .heroWiki: goToComicDetail(segue: segue)
        }
    }
    
    private func zoomHeroImage(segue: UIStoryboardSegue){
        let myVC = segue.destination as? HeroImageViewController
        myVC?.heroImage = heroViewModel?.getHeroUrlImage()
    }

    private func gotToWiki(segue: UIStoryboardSegue,sender: Any?){
        guard let myCell = sender as? ComicCollectionCell,
            let index = comicsCollection.indexPath(for: myCell)?.row else { return }
        
        let myVC = segue.destination as? ComicDetailsViewController
        myVC?.comic = heroViewModel?.getComicAt(index: index)
    }
    
    private func goToComicDetail(segue: UIStoryboardSegue){
        let myVC = segue.destination as? WikiWebViewController
        myVC?.wikiWeb = heroViewModel?.getUrlWiki()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroViewModel?.getComicsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        myCell.comicImage.sd_setImage(with: URL(string: heroViewModel!.getComicUrlImage(atIndex: indexPath.row)),  placeholderImage: nil, options: [], completed: nil)
        return myCell
    }
}
