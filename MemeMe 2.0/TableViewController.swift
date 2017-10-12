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

    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // load table cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let meme = memes[indexPath.row]
        cell.memeThumbnail.image = meme.memeImage
        cell.topBottomDescription.text = meme.topText
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editViewController = storyboard?.instantiateViewController(withIdentifier: "createMemeViewController") as? CreateMemeViewController
        let memeEdit = memes[indexPath.row]
        print(editViewController)
        
        editViewController?.meme = memeEdit
        present(editViewController!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(editViewController!, animated: true)
    }
     */
    
    // MARK: - Create Meme
        
    @IBAction func createMeme(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "createMemeViewController") as? CreateMemeViewController
        present(viewController!, animated: true, completion: nil)
   
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        switch (segue.identifier ?? "") {
        case "Add":
            os_log("Adding a new meme.", log: OSLog.default, type: .debug)
        case "Show":
            guard let createDetailViewController = segue.destination as? CreateMemeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectMealCell = sender as? TableViewCell else {
                fatalError("Unexpected sender: \(sender ?? " ")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectMealCell) else {
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
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                memes[selectedIndexPath.row] = meme
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                
                //Add a new meal
                let newIndexPath = IndexPath(row: memes.count, section: 0)
                memes.append(meme)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
