//
//  BobbleTableViewCell.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit

class BobbleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet var bobbleImageView: UIImageView!
    @IBOutlet var bobbleNameLabel: UILabel!
    @IBOutlet var bobbleRarityLabel: UILabel!
    @IBOutlet var bobbleRarityOutOfLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
