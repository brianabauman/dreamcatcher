//
//  Dream.swift
//  Bauman, Brian Dreamcatcher
//
//  Created by Brian Bauman on 3/14/19.
//  Copyright © 2019 Brian Bauman. All rights reserved.
//

import Foundation

class Dream {

    var title: String
    var category: String
    var description: String
    var tag: String
    var date: Date
    
    init(title: String,
         category: String,
         description: String,
         tag: String,
         date: Date) {
        self.title = title
        self.category = category
        self.description = description
        self.tag = tag
        self.date = date
    }
}
