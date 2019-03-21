//
//  FindCell.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 06/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit

class FindCell: UITableViewCell {

    @IBOutlet weak var findLabel: UITextField!
    @IBOutlet weak var imgLupa: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
