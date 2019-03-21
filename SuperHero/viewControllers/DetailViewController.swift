//
//  DetailViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 28/02/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

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
    
    private let myManager = SuperheroManager()
    
    var myHero: Hero?
    private var urlWiki: String?
    var comicsHero: [Comic]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.wikiButton.isHidden = true

        paintAll()
        
       
    }
    
    func paintAll(){
        paintBorder()
        lookForWiki()
        paintData()
    }
    
    private func lookForWiki(){
        
        guard let hero = myHero else {
            return
        }
        
        myManager.getwikiHero(hero: hero){ [weak self] (urlGiven) in
            
            guard let mySelf = self else{
                return
            }
            
            if urlGiven != nil{
                
                DispatchQueue.main.sync {
                    mySelf.wikiButton.isHidden = false
                }
                
                mySelf.urlWiki = urlGiven
                print("URL: \(mySelf.urlWiki!)")
                
            }
            
        }
    }
    
    private func paintBorder(){
        heroImage.layer.borderWidth = 3.0
        heroImage.layer.borderColor = UIColor.white.cgColor
        heroImage.clipsToBounds = true
    }
    
    private func paintData(){
        
        guard let hero = myHero else {
            return
        }
        
        heroId.text = "ID: \(hero.id)"
        heroImage.sd_setImage(with: URL(string: hero.thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
        
        heroName.text = "\(hero.name)"
        
        heroDescription.text = "DESCRIPTION\n\(hero.heroDescription ?? "") "
        lookForComics()
        
    }
    
    private func lookForComics() {
        
        guard let hero = myHero else {
            return
        }
        
        myManager.getComicsFromHero(heroID: hero.id) { [weak self] comicArray in
            
            guard let mySelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                mySelf.comicsHero = comicArray
                mySelf.comicsCollection.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier, let hero = myHero else{
            return
        }
        
        
        //Zoomea la imagen del heroe
        if(segueId == "tapSegue"){
            
            let myVC = segue.destination as? ModalViewController
            myVC?.heroImage = hero.thumbnail.completePath()
        }
        
        
        //Va al detalle del comic seleccionado
        if (segueId == "comicSegue"){
            
            guard let myCell = sender as? ComicCollectionCell ,let index = comicsCollection.indexPath(for: myCell)?.row else {
                return
            }
            
            let myVC = segue.destination as? ComicViewController
            myVC?.comic = comicsHero?[index]
        
            
        }
        
        //Abre la wiki del heroe
        if (segueId == "heroWikiSegue"){
            
            let myVC = segue.destination as? WikiWebViewController
            myVC?.wikiWeb = urlWiki
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let comics = comicsHero else {
            return 0
        }
        
        return comics.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        
        
        if let comics = comicsHero {
            
            myCell.comicImage.sd_setImage(with: URL(string: comics[indexPath.row].thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
            
        }
        
        
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
