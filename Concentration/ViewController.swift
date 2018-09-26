//
//  ViewController.swift
//  Concentration
//
//  Created by Jack Li on 9/13/18.
//  Copyright © 2018 Jack Li. All rights reserved.
//

/*
 TODO:
 1. Permanent storage of themes
 2. Custom background and card colors based on hex string
 3. Adjust score according to how quickly moves are made
 4. Auto layout and/or other UI enhancements
 */

import UIKit

/* Swift's default colors */
enum Color: String {
    case black
    case blue
    case brown
    case clear
    case cyan
    case darkGray
    case gray
    case green
    case lightGray
    case magenta
    case orange
    case purple
    case red
    case white
    case yellow
    
    var create: UIColor? {
        switch self {
        case .black:
            return UIColor.black
        case .blue:
            return UIColor.blue
        case .clear:
            return UIColor.clear
        case .cyan:
            return UIColor.cyan
        case .darkGray:
            return UIColor.darkGray
        case .gray:
            return UIColor.gray
        case .green:
            return UIColor.green
        case .lightGray:
            return UIColor.lightGray
        case .magenta:
            return UIColor.magenta
        case .orange:
            return UIColor.orange
        case .purple:
            return UIColor.purple
        case .red:
            return UIColor.red
        case .white:
            return UIColor.white
        case .yellow:
            return UIColor.yellow
        default:
            return nil
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var flipsLabel: UILabel!
    
    /* Default themes */
    static var halloween = Theme(backgroundColor: "black", cardColor: "orange", name: "Halloween", emojis: "😈", "👿", "👻", "💀", "🎃", "🙀", "🧛‍♀️", "🧛🏻‍♂️", "🧟‍♀️", "🧟‍♂️", "🧙‍♀️", "🧙‍♂️", "😱")
    
    static var winter = Theme(backgroundColor: "blue", cardColor: "white", name: "Winter", emojis: "❄️", "☃️", "🌨", "🌫", "⛷", "🏂", "🎅", "⛸", "🏒")
    
    static var animals = Theme(backgroundColor: "green", cardColor: "brown", name: "Animals", emojis: "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🙈", "🐔", "🐧", "🐦", "🐤", "🦆")
    
    static var faces = Theme(backgroundColor: "yellow", cardColor: "black", name: "Faces", emojis: "😀", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😉", "😗", "😎", "😤", "😐", "😑", "🙄", "😮")
    
    static var themes = [halloween, winter, animals, faces]
    
    private lazy var concentration = Concentration(n: (cardButtons.count + 1)/2)
    
    private var theme = ViewController.themes[Int.random(in: 0..<ViewController.themes.count)]
    
    private var cardColor: UIColor?
    
    private var cardToEmoji = [Card: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
    }
    
    private var flips = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flips)"
        }
    }
    
    @IBAction func pressedNewGameButton(_ sender: UIButton) {
        concentration.restartGame() // reset card state
        theme = ViewController.themes[Int.random(in: 0..<ViewController.themes.count)] // pick a new theme
        setColors() // reset card and background colors
        cardToEmoji.removeAll() // empty mapping for old emojis
        flips = 0
        updateView()
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            /* flipping a face up card doesn't do anything. NOTE: Not mentioned in the spec but a change I made that I think makes more sense. */
            if concentration.chooseCard(at: index) {
                flips += 1
            }
            updateView()
        }
    }
    
    func setColors() {
        if let color = Color(rawValue: theme.backgroundColor), let backgroundColor = color.create{
            self.view.backgroundColor = backgroundColor
        }
        if let color = Color(rawValue: theme.cardColor), let cardColor = color.create{
            self.cardColor = cardColor
        }
        else {
            self.cardColor = UIColor.orange
        }
    }
    
    func updateView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = concentration.cards[index]
            if card.faceUp {
                let emoji = getEmoji(for: card)
                /*
                card.matched ? button.setTitle("", for: UIControl.State.normal) : button.setTitle(emoji, for: UIControl.State.normal)
                button.backgroundColor = card.matched ? UIColor.clear : UIColor.white
                */
                button.setTitle(emoji, for: UIControl.State.normal)
                button.backgroundColor = UIColor.white
            }
            else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = cardColor
            }
            /* Matched cards disappear immediately */
            if card.matched {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = UIColor.clear
            }
        }
        scoreLabel.text = "Score: \(concentration.score)"
    }
    
    func getEmoji(for card: Card) -> String {
        if let emoji = cardToEmoji[card] { // cards with same id have same emojis
            return emoji
        }
        else {
            if let randomEmoji = theme.emojis.randomElement() {
                cardToEmoji[card] = randomEmoji
                theme.emojis.remove(randomEmoji) // so we don't pick the same element again for the current game
            }
            else { // should never execute but just in case
                cardToEmoji[card] = "?"
            }
        }
        return cardToEmoji[card]!
    }
}
