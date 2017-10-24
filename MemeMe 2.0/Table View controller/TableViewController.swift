//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by Satveer Singh on 7/23/17.
//  Copyright © 2017 Satveer Singh. All rights reserved.
//

import UIKit
import os.log

class TableViewController: UITableViewController {
    var memes = [Meme] ()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display an Left Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return appDelegate.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // load table cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let meme = appDelegate.memes[indexPath.row]
        cell.memeThumbnail.image = meme.memeImage
        cell.topBottomDescription.text = meme.topText
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Setup Image for detail view controller.
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        let memeCell = appDelegate.memes[indexPath.row]
        detailViewController.image = memeCell.memeImage
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateMemeViewController, let meme = sourceViewController.meme {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                appDelegate.memes[selectedIndexPath.row] = meme
            } else {
                
                //Add a new meal
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
            }
        }
    }
}
