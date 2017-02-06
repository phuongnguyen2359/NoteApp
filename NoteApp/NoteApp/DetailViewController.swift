//
//  DetailViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var nodeTitle: String!
    var nodeContent: String!
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    
    var note:Notes!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = note.title
        txtContent.text = note.content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editNote(_ sender: Any) {
        
    }
}
