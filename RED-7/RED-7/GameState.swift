//
//  GameState.swift
//  RED-7
//
//  Created by Михаил Первеев on 17.12.2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import Foundation

class GameState {
    private var playersCount: Int
    private var deckCards: Array<Card>
    private var canvasCard: Card
    private var playerStates: Array<PlayerState>
    private var playerTurn: Int
    
    init(playersCount: Int) {
        self.playersCount = playersCount
        
        self.deckCards = Array<Card>()
        for number in 1...7 {
            self.deckCards.append(Card(color: .blue, number: number))
            self.deckCards.append(Card(color: .green, number: number))
            self.deckCards.append(Card(color: .navy, number: number))
            self.deckCards.append(Card(color: .orange, number: number))
            self.deckCards.append(Card(color: .purple, number: number))
            self.deckCards.append(Card(color: .red, number: number))
            self.deckCards.append(Card(color: .yellow, number: number))
        }
        self.deckCards.shuffle()
        
        self.canvasCard = Card(color: .red, number: 0)
        
        self.playerStates = Array<PlayerState>()
        for _ in 1...playersCount {
            var playerCards = Array<Card>()
            
            for _ in 1...7 {
                playerCards.append(self.deckCards.popLast()!)
            }
            
            self.playerStates.append(PlayerState(handCards: playerCards))
            self.playerStates.last!.addPaletteCard(card: self.deckCards.popLast()!)
        }
        
        self.playerTurn = 0
        for player in 1...playersCount - 1 {
            if compareRedStates(first: self.playerStates[self.playerTurn], second: self.playerStates[player]) == 1 {
                self.playerTurn = player
            }
        }
    }
    
    public func getCanvasCard() -> Card {
        return self.canvasCard
    }
    
    public func getFocusedPaletteCards() -> Array<Card> {
        return self.playerStates[playerTurn].getPaletteCards()
    }
    
    public func getOtherPaletteCards() -> Array<Card> {
        return self.playerStates[1 - playerTurn].getPaletteCards()
    }
    
    public func getFocuseddHandCards() -> Array<Card> {
        return self.playerStates[playerTurn].getHandCards()
    }
}
