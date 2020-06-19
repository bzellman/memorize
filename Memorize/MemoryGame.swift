//
//  MemoryGame.swift
//  Memorize
//
//  Created by Bradley Zellman on 5/20/20.
//  Copyright © 2020 Bradley Zellman. All rights reserved.
//

import Foundation
import UIKit

struct MemoryGameDetails {
    var name: String
    var emojis: [String]
    var color: UIColor
    var numberOfCards: Int
    
    init(name: String, emojis: [String], color: UIColor, numberOfCards: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfCards = numberOfCards
    }
}

struct MemoryGame<CardContent> where CardContent: Equatable{
    
    var cards: Array<Card>
    var themeColor: UIColor
    var score: Int
    var themeName: String
    var isGameInProgress: Bool
    
    var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get { cards.indices.filter {  cards[$0].isFaceUp }.only  }
        set {
            for index in cards.indices {
                    cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    score -= 1
                }
                self.cards[chosenIndex].isFaceUp = true
                isGameInProgress = checkToSeeIfGameIsInProgress()
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
        }
    }
    
    mutating func checkToSeeIfGameIsInProgress() -> Bool {
        for card in cards {
            if !card.isMatched {
                return true
            }
        }
        return false
    }

    
    init(numberOfPairsOfCards: Int, themeColor: UIColor, score: Int = 0, themeName: String, isGameInProgress: Bool, cardContentFactory: (Int) -> CardContent ) {
        cards = Array<Card>()
        self.themeColor = themeColor
        self.score = score
        self.themeName = themeName
        self.isGameInProgress = isGameInProgress
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content,  id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
