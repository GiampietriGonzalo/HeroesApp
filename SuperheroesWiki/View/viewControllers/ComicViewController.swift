import UIKit
import SDWebImage

class ComicViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pintAll()
    }

    private func pintAll(){
        paintLabels()
        paintComicImage()
    }
    
    private func paintLabels(){
        guard let myComic = comic else{ return }
        titleLabel.text = myComic.title
        descriptionLabel.text = "DESCRIPTION\n\(myComic.comicDescription ?? "")"
        idLabel.text = "ID: \(myComic.id)"
    }
    
    private func paintComicImage(){
         image.sd_setImage(with: URL(string: self.comic!.thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
    }
}


