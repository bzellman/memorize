//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Bradley Zellman on 5/19/20.
//  Copyright © 2020 Bradley Zellman. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @State private var showingGameSheet: Bool = false
    var buttonArray: [ActionSheet.Button] = []
    
    init() {
        self.viewModel = EmojiMemoryGame()
        
    }
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("\(viewModel.themeName)")
                    .padding()
                Spacer()
                Text("Score: \(viewModel.score)")
                .padding()
            }
            .padding()
            
            if viewModel.isGameInProgress {
                Grid(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            self.viewModel.choose(card: card)
                        }
                .padding(5)
                }
                .padding()
                .foregroundColor(Color(viewModel.themeColor))
            } else {
                Spacer()
                Button(action: {
                    self.viewModel.currentGameType = self.viewModel.dictionaryOfGameTypes.randomElement()?.value
                }) {
                    Text("Start a Game")
                }
                Spacer()
            }
            
            HStack {
                Button(action: {
                    self.showingGameSheet = true
                }) {
                    Text("Choose Game")
                }
                Spacer()
                Button(action: {
                    self.viewModel.currentGameType = self.viewModel.dictionaryOfGameTypes.randomElement()?.value
                }) {
                    Text("New Game")
                }
            }
            
            .actionSheet(isPresented: $showingGameSheet) {
                ActionSheet(title: Text("Choose A New Game"), message: Text("Select a Game Type To Play"), buttons: self.viewModel.buttonArray)
            }
            
            .padding()
        }
        
    }
}
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        
            GeometryReader { geometry in
                    self.body(for: geometry.size)
                }
        
    }
    
    func body(for size: CGSize) -> some View {
            ZStack {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(self.card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                    
                }
            }
            
        .font(Font.system(size: min(size.width, size.height) * fontScaleFactor))
    }
    
    // MARK: Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let fontScaleFactor: CGFloat = 0.75
    let edgeLineWidth: CGFloat = 3
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView()
    }
}
