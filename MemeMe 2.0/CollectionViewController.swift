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

@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [Meme] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let space:CGFloat = 3.0
//        let dimension = (view.frame.size.width - (2 * space)) / 3.0
//
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = space
//        flowLayout.itemSize = CGSize(width: dimension, height: dimension)        // Do any additional setup after loading the view.
//        print("Collection")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        appDelegate.memes.append(Meme(topText: "hellow", bottomText: "World", oldImage: #imageLiteral(resourceName: "defaultPhoto"), memeImage: #imageLiteral(resourceName: "defaultPhoto")))
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Error")
        }
        
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(indexPath)
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "createMemeViewController") as? CreateMemeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        switch (segue.identifier ?? "") {
        case "AddCollection":
            os_log("Adding a new meme.", log: OSLog.default, type: .debug)
        case "ShowCollection":
            guard let createDetailViewController = segue.destination as? CreateMemeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectMealCell = sender as? CollectionViewCell else {
                fatalError("Unexpected sender: \(sender ?? " ")")
            }
            guard let indexPath = collectionView?.indexPath(for: selectMealCell) else {
            //guard let indexPath = tableView.indexPath(for: selectMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let memeCell = memes[indexPath.row]
            createDetailViewController.meme = memeCell
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? " ")")
        }
    }
    
    // MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateMemeViewController, let meme = sourceViewController.meme {
            let indexPaths = collectionView!.indexPathsForSelectedItems
            let firstIndexPath = indexPaths![0] as NSIndexPath
            print(firstIndexPath)
            guard let p = indexPaths?.count else {
                fatalError("Error")
            }
            if p > 0 {
                
                //Update an existing meal
                memes[p] = meme
                collectionView!.reloadItems(at: indexPaths!)
            }
            else {

                //Add a new meal
                let newIndexPath = IndexPath(row: memes.count, section: 0)
                memes.append(meme)
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                collectionView?.insertItems(at: [newIndexPath])
                
            }
        }
    }
}
