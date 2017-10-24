//
//  DetailViewController.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 9/10/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //var meme: Meme!
    @IBOutlet weak var memedImage: UIImageView!
    var image:  UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Memed image from selected section
        self.memedImage.image = image
    }
}
