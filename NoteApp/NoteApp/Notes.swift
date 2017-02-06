//
//  Notes.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/6/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import Foundation


class Notes: NSObject {
    
    let title: String?
    let content: String?
    
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}

