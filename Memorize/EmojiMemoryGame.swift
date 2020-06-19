//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bradley Zellman on 5/20/20.
//  Copyright © 2020 Bradley Zellman. All rights reserved.
//

import Foundation
import SwiftUI


struct EmojiGameType {
    let halloween: MemoryGameDetails = MemoryGameDetails(name: "Halloween", emojis: [ "👻","🎃","🕷","🕯","🔮"], color: UIColor.orange, numberOfCards: 5)
    let flags: MemoryGameDetails = MemoryGameDetails(name: "Flags", emojis: [ "🇺🇸", "🏳️‍🌈", "🇺🇳", "🏁", "🇧🇧", "🇫🇴"], color: UIColor.purple, numberOfCards: 6)
    let emotion: MemoryGameDetails = MemoryGameDetails(name: "Emotion", emojis: [ "🙃", "😂", "😝", "😎","🤪","😍"], color: UIColor.cyan, numberOfCards: 6)
    let activities: MemoryGameDetails = MemoryGameDetails(name: "Activities", emojis: [ "🧘‍♂️", "🏋️", "🏂", "🤽‍♂️", "🚴‍♂️","🚣"], color: UIColor.gray, numberOfCards: 4)
    let places: MemoryGameDetails = MemoryGameDetails(name: "Places", emojis: [ "🏖", "🏔", "🏕", "🏠", "🏰", "🗽"], color: UIColor.green, numberOfCards: Int.random(in: 2...6))
    let animals: MemoryGameDetails = MemoryGameDetails(name: "Animals", emojis: [ "🐻", "🐶", "🐵", "🦊", "🦁", "🐼"], color: UIColor.brown, numberOfCards: Int.random(in: 2...6))
}

final class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String>?
    let mirrorOfGameTypes = Mirror(reflecting: EmojiGameType())
    var dictionaryOfGameTypes: [String:MemoryGameDetails] = [:]
    var buttonArray: [ActionSheet.Button] = []

    var currentGameType: MemoryGameDetails? {
        didSet {
            model = EmojiMemoryGame.createMemoryGame(emojiGameType: currentGameType!)
        }
    }
    
    init() {
        for child in mirrorOfGameTypes.children {
            dictionaryOfGameTypes[child.label!] = child.value as? MemoryGameDetails
        }
        currentGameType = self.dictionaryOfGameTypes.randomElement()!.value
        loadButtonArrayForActionSheet()
        model = EmojiMemoryGame.createMemoryGame(emojiGameType: currentGameType!)
    }
    
    static func createMemoryGame(emojiGameType: MemoryGameDetails) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: emojiGameType.numberOfCards, themeColor: emojiGameType.color, themeName: emojiGameType.name, isGameInProgress: true) { pairIndex in
            return emojiGameType.emojis[pairIndex] }
        
    }
    
    func loadButtonArrayForActionSheet() {
        for item in self.dictionaryOfGameTypes {
            self.buttonArray.append(
                ActionSheet.Button.default(Text(item.value.name), action: {
                    self.currentGameType = item.value
            }))
        }
        self.buttonArray.append(ActionSheet.Button.cancel())
    }
    
    
    // MARK: Access to the Model

    var cards: Array<MemoryGame<String>.Card> {
        model!.cards
    }
    
    var score: Int {
        model!.score
    }
    
    var themeName: String {
        model!.themeName
    }
    
    var themeColor: UIColor {
        model!.themeColor
    }
    
    var isGameInProgress: Bool {
        model!.isGameInProgress
    }
    
    // MARK: Intents
    
    func choose(card: MemoryGame<String>.Card){
        objectWillChange.send()
        model!.choose(card: card)
    }
}
