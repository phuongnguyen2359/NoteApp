//
//  AddViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        titleTextField.delegate = self
    }
    
    @IBAction func doneDidTouch(_ sender: Any) {
        if ((titleTextField.text?.isEmpty)! || (contentTextView.text.isEmpty)){
            showAlert(title: "Error", message: "Please enter Title or Content")
        } else{
            increment()
            addNote()
            titleTextField.text = ""
            contentTextView.text = ""
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: UITextViewDelegate for content textfiled
extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.text = ""
        contentTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.textColor = UIColor.black
        }
        
    }
}


// MARK: UITextFieldDelegate for title textfiled
extension AddViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleTextField.text = ""
        titleTextField.textColor = UIColor.black
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddViewController {
    
    // Mark: increment Id value by 1
    func increment() {
        id += 1
    }
    
    // Mark: create alter message
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Mark: Add note to firebase database
    func addNote(){
        let currentUsr = Users.accountName(email: (FIRAuth.auth()?.currentUser?.email)!)
        let title = titleTextField.text
        let content = contentTextView.text
        let noteID = "note_\(id)"
        let noteIndex = "\(id)"
        if let title = title , let content = content {
            let post: [String: String] = ["title" : title,
                                          "content": content,
                                          "noteIndex": noteIndex]
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("Users").child("\(currentUsr)").child("Notes").child("\(noteID)").setValue(post)
        }
    }
}

