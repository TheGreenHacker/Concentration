//
//  Cards.swift
//  Concentration
//
//  Created by Jack Li on 9/13/18.
//  Copyright © 2018 Jack Li. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var faceUp = false
    var matched = false
    var mismatched = false
    let id: Int // card's id doesn't need to change
    
    var hashValue: Int {
        return id
    }
    
    /* IMPORTANT: Just because two objects have the same hash value does NOT mean they are equal. This is to establish card equivalence based on only id. */
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(n: Int) {
        id = n.hashValue
    }
}
