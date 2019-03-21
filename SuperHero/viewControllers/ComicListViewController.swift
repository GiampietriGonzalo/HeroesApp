//
//  ComicListViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 12/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

class ComicListViewController: UIViewController{

    @IBOutlet weak var comicCollection: UICollectionView!
    @IBOutlet var myView: UIView!
    
    var myComics: [Comic]?
    var myManager: SuperheroManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        myManager = SuperheroManager()
    }
    

    private func lookForComics(){
        
        myManager?.getComics() { [weak self] comicArray in
            
            guard let mySelf = self else {
                return
            }
            
            
            DispatchQueue.main.async {
                mySelf.myComics = comicArray
                mySelf.comicCollection.reloadData()
            }
        }
        
    }
}

extension ComicListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let comics = myComics else{
            return 0
        }
        
        return comics.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = comicCollection.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionCell
        initComicCell(cell: myCell, row: indexPath.row)
        return myCell
    }
    
    private func initComicCell(cell: ComicCollectionCell, row: Int){
        
        if let comics = myComics {
            cell.comicImage.sd_setImage(with: URL(string: comics[row].thumbnail.completePath()!),  placeholderImage: nil, options: [], completed: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier, let comics = myComics else{
            return
        }
        
        if (segueId == "comicDetailSegue"){
            
            guard let myCell = sender as? ComicCollectionCell ,let index = comicCollection.indexPath(for: myCell)?.row else {
                return
            }
            
            let myVC = segue.destination as? ComicViewController
            myVC?.comic = comics[index]
            
        }
        
    }
    
   
}

