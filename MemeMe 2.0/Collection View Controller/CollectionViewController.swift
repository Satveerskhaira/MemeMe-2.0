//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 7/23/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addBarButton : UIBarButtonItem!
    @IBOutlet var detailShow: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [Meme] ()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Set Cell layout
        let itemSize = UIScreen.main.bounds.width/3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        detailShow.collectionViewLayout = layout
       
        appDelegate.memes.append(Meme(topText: "Hello", bottomText: "World", oldImage: #imageLiteral(resourceName: "Original") , memeImage: #imageLiteral(resourceName: "memed")))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reload collection
        self.collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number if cell based on memes array record.
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Error")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        cell.delegate = self
        return cell
    }
    
    
    // MARK : Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(animated, animated: true)
        addBarButton.isEnabled = !editing
        //Change Left bar button
        if !editing {
            self.editButtonItem.title = "Edit"
        }
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.isEditing = editing
                }
            }
        }
    }


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setup Image for detail view controller.
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        let memeCell = appDelegate.memes[indexPath.row]
        detailViewController.image = memeCell.memeImage
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateMemeViewController, let meme = sourceViewController.meme {
            guard let indexPaths = collectionView!.indexPathsForSelectedItems else {
                fatalError("error")
            }
            let p = indexPaths.last?.row
            if indexPaths.isEmpty {
                //Add new meme
                appDelegate.memes.append(meme)
            } else {
                //Update existing Meme
                appDelegate.memes[p!] = meme
            }
            
        }
    }
}

//MARK : Make collectionView Delegate of cell
extension CollectionViewController: CollectionViewCellDelegate {
    func deleteFunction(memeCell: CollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: memeCell) {
            // Delete data from meme array data source
                appDelegate.memes.remove(at: indexPath.row)
            // Delele cell from selected index path
            collectionView?.deleteItems(at: [indexPath])
        }
    }
}
