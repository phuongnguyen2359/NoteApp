//
//  HomeViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase


//struct noteStruct {
//    let title: String!
//    let content: String!
//}

class HomeViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = true
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Notes").queryOrderedByKey().observe(.childAdded, with: { (
            snapshot) in
            let snapshotValue = snapshot.value  as? NSDictionary
            let title = snapshotValue?["title"] as? String
            let content = snapshotValue?["content"] as? String
            self.notes.insert(Notes(title: title!, content: content!), at: 0)
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let selectedRow = tableView.indexPathForSelectedRow?.row
            if let des = segue.destination as? DetailViewController {
                des.nodeTitle = notes[(selectedRow)!].title
                
                des.note = notes[selectedRow!]
                
            }
        }
    }
}


// TableView setting
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! titleCell
        cell.titleNoteLable.text = notes[indexPath.row].title! as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
//        let titleID = self.notes[indexPath.row].title
//        
//        FIRDatabase.database().reference().child("Notes").child(titleID!).removeValue { (error, ref) in
//            if error != nil {
//                print("falied to delete")
//                return
//            }
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        print(indexPath.row)
    }

}

