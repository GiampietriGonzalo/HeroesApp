import UIKit

struct HeroDetailsInput: Input {
    var hero: Hero?
}

struct HeroDetailsOutput: Output {
    var hero: Hero?
    var comic: Comic?
}

class HeroDetailsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroId: UILabel!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var comicsCollection: UICollectionView!
    @IBOutlet weak var wikiButton: UIBarButtonItem!
    @IBOutlet weak var backImage: UIImageView!
    var presenter: HeroDetailPresenterProtocol?
    
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
        presenter?.lookForHero(){ [weak self] in
            guard let self = self else{ return }
            
            self.performSelector(onMainThread: #selector(self.setLablesData), with: nil, waitUntilDone: true)
            self.heroImage!.sd_setImage(with: URL(string: self.presenter?.getHeroUrlImage() ?? ""), placeholderImage: nil, options: [], completed: nil)
        }
         lookForComics()
    }
    
    @objc private func setLablesData(){
        heroId.text = "ID: \(presenter?.getHeroID() ?? 0000 )"
        heroName.text = presenter?.getHeroName()
        heroDescription.text = "DESCRIPTION\n\(presenter?.getHeroDescription() ?? Messages.DESCRIPTION_NOT_FOUND) "
        disableWikiButton()
    }
    
   private func lookForComics() {
        presenter?.lookForComics { [weak self] in
            guard let self = self else { return }
            self.performSelector(onMainThread: #selector(self.reloadTableViewData), with: nil, waitUntilDone: true)
            self.performSelector(onMainThread: #selector(self.enabledWikiButton), with: true, waitUntilDone: true)
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
        case .heroDetailsToImageZoomed:
            zoomHeroImage(segue: segue)
        case .heroDetailsToComicDetails:
            gotToComicDetails(segue: segue, sender: sender)
        case .heroDetailsToHeroWiki:
            goToWiki(segue: segue)
        default:
            break
        }
    }
    
    private func zoomHeroImage(segue: UIStoryboardSegue){
        let heroImageVC = segue.destination as? HeroImageViewController
        heroImageVC?.heroImage = presenter?.getHeroUrlImage()
    }

    private func gotToComicDetails(segue: UIStoryboardSegue,sender: Any?){
        guard let myCell = sender as? ComicCollectionCell,
            let index = comicsCollection.indexPath(for: myCell)?.row else { return }
        
        let comicDetailsVC = segue.destination as? ComicDetailsViewController
        comicDetailsVC?.input = ComicDetailsInput(comic: presenter?.getComicAt(index: index))
    }
    
    private func goToWiki(segue: UIStoryboardSegue){
        let wikiVC = segue.destination as? WikiWebViewController
        wikiVC?.wikiWeb = presenter?.getUrlWiki()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getComicsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let comicCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViews.CELL_COMIC, for: indexPath) as! ComicCollectionCell
        comicCell.comicImage.sd_setImage(with: URL(string: presenter!.getComicUrlImage(atIndex: indexPath.row)),  placeholderImage: nil, options: [], completed: nil)
        return comicCell
    }
}
