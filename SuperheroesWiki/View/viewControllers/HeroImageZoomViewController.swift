import UIKit
import SDWebImage

class HeroImageZoomViewController: UIViewController {
    
    var heroImage: String?
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintAll()
    }
    
    public func paintAll(){
        
        guard let urlImage = heroImage else{
            return
        }
        
        img?.sd_setImage(with: URL(string: urlImage),  placeholderImage: nil, options: [], completed: nil)
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion:nil)
    } 
}
