//
//  HeroCellControllerTableViewCell.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 28/02/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

class HeroCell: UITableViewCell {

    static var size = 100.0
    
    @IBOutlet weak var heroimg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
