//
//  HomeViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notes.removeAll()
        loadTableData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let selectedRow = tableView.indexPathForSelectedRow?.row
            if let des = segue.destination as? DetailViewController {
                des.nodeTitle = notes[(selectedRow)!].title // should delete here
                des.note = notes[selectedRow!]
            }
        } else if (segue.identifier == "addSegue"){
            if let des = segue.destination as? AddViewController{
                des.id = notes.count
            }
        }
    }
}

// Mark: TableView setting
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
        deleteRow(toValue: notes[indexPath.row].noteIndex, indexPath: indexPath.row)
    }
}

extension HomeViewController {
    
    @IBAction func logoutDidTouch(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        Users.currentUser = nil
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController")
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func loadTableData() {
        let currentUsr = Users.accountName(email: (FIRAuth.auth()?.currentUser?.email)!)
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("Users").child("\(currentUsr)").child("Notes").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value  as? NSDictionary
            let title = snapshotValue?["title"] as? String
            let content = snapshotValue?["content"] as? String
            let noteIndex = snapshotValue?["noteIndex"] as? String
            self.notes.insert(Notes(title: title!, content: content!, noteIndex: noteIndex!), at: 0)
            self.notes.sort(by: {$0.noteIndex < $1.noteIndex})
            self.tableView.reloadData()
        })
    }
    
    func deleteRow(toValue: String, indexPath: Int) {
        let currentUsr = Users.accountName(email: (FIRAuth.auth()?.currentUser?.email)!)
        FIRDatabase.database().reference().child("Users").child("\(currentUsr)").child("Notes").queryOrdered(byChild: "noteIndex").queryEqual(toValue: "\(toValue)").observeSingleEvent(of: .value, with: { (Snap) in
            if let snapDict = Snap.value as? [String: AnyObject] {
                for each in snapDict {
                    let noteId = "\(each.key)"
                    FIRDatabase.database().reference().child("Users").child("\(currentUsr)").child("Notes").child("\(noteId)").removeValue { (error, ref) in
                        if error != nil {
                            print("\(error)")
                            return
                        }
                    }
                    self.notes.remove(at: indexPath)
                    self.tableView.reloadData()
                }
            }
        })
    }
}
