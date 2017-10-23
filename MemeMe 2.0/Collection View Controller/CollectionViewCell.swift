//
//  CollectionViewCell.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 9/10/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    @IBOutlet weak var memeImage: UIImageView! {
        didSet {
            deleteButtonBlurView.layer.cornerRadius = deleteButtonBlurView.bounds.width / 2
            deleteButtonBlurView.layer.masksToBounds = true
            deleteButtonBlurView.isHidden = !isEditing
        }
    }
    @IBOutlet weak var deleteButtonBlurView: UIVisualEffectView!
    
    
    var isEditing = false {
        didSet {
            deleteButtonBlurView.isHidden = !isEditing
        }
    }
    @IBAction func deleteCell(_ sender: Any) {
        delegate?.deleteFunction(memeCell: self)
    }
    
}

protocol CollectionViewCellDelegate: class {
    func deleteFunction(memeCell :CollectionViewCell)
}
