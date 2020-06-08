//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Bradley Zellman on 5/20/20.
//  Copyright © 2020 Bradley Zellman. All rights reserved.
//

import Foundation


final class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = [ "👻","🎃","🕷","🕯","🔮"]
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...emojis.count) ) { pairIndex in
            return emojis[pairIndex] }
    }
    
    
    // MARK: Access to the Model

    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    // MARK: Intents
    
    func choose(card: MemoryGame<String>.Card){
        objectWillChange.send()
        model.choose(card: card)
    }
}
