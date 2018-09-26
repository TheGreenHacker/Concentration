//
//  Theme.swift
//  Concentration
//
//  Created by Jack Li on 9/13/18.
//  Copyright © 2018 Jack Li. All rights reserved.
//

/*
 TODO:
 1. Hex string property to implement colors not specified in Swift's default collection. 
 */
import Foundation

struct Theme {
    var emojis = Set<String>()  // master set of all emojis available for this theme
    var backgroundColor: String
    var cardColor: String
    var name: String // useful for permanent storage bookkeeping
    
    init(backgroundColor: String, cardColor: String, name: String, emojis: String...) {
        self.backgroundColor = backgroundColor
        self.cardColor = cardColor
        self.name = name
        for emoji in emojis {
            self.emojis.insert(emoji)
        }
    }
}


