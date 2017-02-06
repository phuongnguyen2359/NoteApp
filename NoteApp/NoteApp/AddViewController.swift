//
//  AddViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addNote(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
       // postNote()
    }
    
    func postNote(){
        let title = titleTextField.text
        let content = contentTextView.text
        if let title = title , let content = content{
            let post: [String: String] = ["title" : title,
                                      "content": content]
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Notes").childByAutoId().setValue(post)
        }
    }

}


extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.text = ""
        contentTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "Add your content here..."
            contentTextView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
