//
//  LoginViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/8/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameResTextFiled: UITextField!
    @IBOutlet weak var emailResTextField: UITextField!
    @IBOutlet weak var passResTextField: UITextField!
    
    lazy var homeNavigationController: UINavigationController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let holder = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        return holder as! UINavigationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.isHidden = false
        registerView.isHidden = true
        
    }
    
    @IBAction func segmentLoginRegister(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.loginView.isHidden = false
                self.registerView.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.loginView.isHidden = true
                self.registerView.isHidden = false
            })
        }
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
        guard let email = emailTextField.text, email.isEmpty == false else {
            self.showAlert(title: "Opp!", message: "Please enter your email")
            return
        }
        
        guard let password = passwordTextField.text, password.isEmpty == false else {
            self.showAlert(title: "Opp!", message: "Please enter your password")
            return
        }
        
        self.login(email: email, password: password)
    }
    
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        let emailRes = emailResTextField.text
        let passwordRes = passResTextField.text
        if let emailRes = emailRes, let passwordRes = passwordRes{
            self.creatAccount(email: emailRes, password: passwordRes)
            emailResTextField.text = ""
            passResTextField.text = ""
            nameResTextFiled.text = ""
        }
    }
    
}

extension LoginViewController {
    
    func creatAccount(email: String, password: String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (usr, error) in
            if error != nil {
                self.showAlert(title: "Error", message: "Something's wrong, please check it again")
            } else {
                self.showAlert(title: "Sign Up", message: "Account has been created successfully")
            }
        })
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (FRIuser, error) in
            if error != nil {
                self.showAlert(title: "Error", message: "Email or Password incorrect")
            } else {
                let userDictionary = ["password": password, "email": email]
                let user = Users(dictionary: userDictionary as NSDictionary)
                Users.currentUser = user
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.present(self.homeNavigationController, animated: true, completion: nil)
            }
        })
    }
    
    // Mark: create alter message
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
