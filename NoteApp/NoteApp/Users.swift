//
//  Users.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/8/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import Foundation

class Users: NSObject {
    let email: String?
    let password: String?
    var dictionary: NSDictionary?    
    static  var _currentUser: Users?
    let currentUserKey = "kCurrentUserKey"
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
        
    }
    
    class var currentUser: Users? {
        get {
            if _currentUser == nil {
                let userData = UserDefaults.standard.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: userData as Data, options: [])
                        _currentUser = Users(dictionary: dictionary as! NSDictionary)
                    } catch  {
                        print("\(error)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if let user = user {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user.dictionary!, options: JSONSerialization.WritingOptions())
                    
                    UserDefaults.standard.set(data, forKey: "currentUserData")
                    
                } catch {
                    print("\(error)")
                }
            }
            else {
                UserDefaults.standard.set(nil, forKey: "currentUserData")
            }
            UserDefaults.standard.synchronize()
        }
    }
}
