import UIKit
import WebKit

class WikiWebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var loadWikiWeb: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var wikiWeb: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pintAll()
        
    }
    
    func pintAll(){
        
        webView.navigationDelegate = self
        self.view.bringSubviewToFront(self.loadWikiWeb)
        let url = URL(string: wikiWeb!)
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        loadWikiWeb.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadWikiWeb.stopAnimating()
        loadWikiWeb.removeFromSuperview()
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
