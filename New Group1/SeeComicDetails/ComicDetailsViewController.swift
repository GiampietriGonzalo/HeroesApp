import UIKit
import SDWebImage


struct ComicDetailsInput: Input {
    var comic: Comic?
}

protocol ComicDetailsViewControllerProtocol {}

class ComicDetailsViewController: UIViewController, ComicDetailsViewControllerProtocol {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var input: Input?
    var presenter: ComicDetailsPresenter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ComicDetailsConfigurator.configure(controller: self, with: input)
        pintAll()
        
    }

    private func pintAll(){
        paintLabels()
        paintComicImage()
    }
    
    private func paintLabels(){
        titleLabel.text = presenter?.getComicTitle()
        descriptionLabel.text = "DESCRIPTION\n\(presenter?.getComicDescription() ?? Messages.DESCRIPTION_NOT_FOUND)"
        idLabel.text = "ID: \(String(describing: presenter?.getComicID()))"
    }
    
    private func paintComicImage(){
         image.sd_setImage(with: URL(string: presenter?.getComicUrlImage() ?? Messages.IMAGE_NOT_FOUND),  placeholderImage: nil, options: [], completed: nil)
    }
}


