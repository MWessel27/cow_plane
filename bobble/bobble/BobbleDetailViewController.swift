//
//  BobbleDetailViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import bobbleFramework

class BobbleDetailViewController: UIViewController {

    var delegate: viewBobble?
    var bobble: Bobble?
    
    @IBOutlet var bobbleNameLabel: UILabel!
    @IBOutlet var bobbleImageView: UIImageView!
    @IBOutlet var bobbleNumberLabel: UILabel!
    @IBOutlet var bobbleOutOfLabel: UILabel!
    @IBOutlet var bobbleDescription: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bobbleNameLabel.text = bobble?.name
        bobbleImageView.image = UIImage(named: String(bobble!.image))
        bobbleNumberLabel.text = String(bobble!.number)
        bobbleOutOfLabel.text = String(bobble!.outOf)
        bobbleDescription.text = bobble?.bobbleDescription
    }


}
