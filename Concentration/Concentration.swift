//
//  Concentration.swift
//  Concentration
//
//  Created by Jack Li on 9/13/18.
//  Copyright © 2018 Jack Li. All rights reserved.
//

/*
 TODO:
 1. Adjust score according to how quickly moves are made
 */

import Foundation

class Concentration {
    var cards = [Card]()
    
    private(set) var score = 0
    
    var indexOfOneFaceUpCard: Int? //make optional since there might not always be one card that's faced up
    
    init(n: Int) {
        for i in 1...n {
            let card = Card(n: i)
            cards.append(card)
            cards.append(card)
        }
        cards.shuffle()
    }
    
    func restartGame() {
        score = 0
        for index in cards.indices {
            cards[index].faceUp = false
            cards[index].matched = false
            cards[index].mismatched = false
        }
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) -> Bool {
        if !cards[index].matched {
            /* One card is currently faced up. Check for potential match */
            if let matchedIndex = indexOfOneFaceUpCard {
                if matchedIndex != index {
                    if cards[matchedIndex].id == cards[index].id { // matching cards have same id
                        cards[matchedIndex].matched = true
                        cards[index].matched = true
                        score += 2
                    }
                    else if cards[matchedIndex].mismatched && cards[index].mismatched{ //double penalty
                        score -= 2
                    }
                    else if cards[index].mismatched || cards[matchedIndex].mismatched { //single penalty
                        if cards[index].mismatched {
                            cards[matchedIndex].mismatched = true
                        }
                        else {
                            cards[index].mismatched = true
                        }
                        score -= 1
                    }
                    else {
                        /* First time both cards have been mismatched so no penalty yet */
                        cards[matchedIndex].mismatched = true
                        cards[index].mismatched = true
                    }
                    indexOfOneFaceUpCard = nil  //2 cards are now faced up
                }
                else {
                    return false
                }
            }
            /* Two cards are faced up and one of them has been tapped. Don't count the flip */
            else if cards[index].faceUp {
                return false
            }
            /* No more than 2 cards can be faced up at the same time */
            else {
                for i in cards.indices{
                    cards[i].faceUp = false
                }
                indexOfOneFaceUpCard = index
            }
            cards[index].faceUp = true
            return true
        }
        return false
    }
}
