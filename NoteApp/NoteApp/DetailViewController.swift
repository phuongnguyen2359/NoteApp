//
//  DetailViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    
    var nodeTitle: String!
    var nodeContent: String!
    var note:Notes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = note.title
        txtContent.text = note.content
    }
    
    @IBAction func editDidTouch(_ sender: Any) {
        let title = txtTitle.text
        let content = txtContent.text
        let noteID = "note_\(note.noteIndex)"
        let noteIndex = note.noteIndex
        if let title = title , let content = content {
            let post: [String: String] = ["title" : title,
                                          "content": content,
                                          "noteIndex": noteIndex]
            
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("Notes").child("\(noteID)").updateChildValues(post)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

