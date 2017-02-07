//
//  Notes.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Notes: NSObject {
    
    let title: String?
    let content: String?
    let noteIndex: String
    var notes = [Notes]()

    init(title: String, content: String, noteIndex: String) {
        self.title = title
        self.content = content
        self.noteIndex = noteIndex
    }
    
    
    func notesFun() -> [Notes] {
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Notes").queryOrderedByKey().observe(.childAdded, with: { (
            snapshot) in
            let snapshotValue = snapshot.value  as? NSDictionary
            let title = snapshotValue?["title"] as? String
            let content = snapshotValue?["content"] as? String
            let noteIndex = snapshotValue?["noteIndex"] as? String
            self.notes.insert(Notes(title: title!, content: content!, noteIndex: noteIndex!), at: 0)
            self.notes.sort(by: {$0.noteIndex < $1.noteIndex})
        })
        print("note count from model \(notes.count)")
        return notes
    }
}

