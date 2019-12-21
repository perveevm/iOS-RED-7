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
    
    private var newPalette: Card?
    private var newCanvas: Card?
    
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
    
    public func getFocusedHandCards() -> Array<Card> {
        return self.playerStates[playerTurn].getHandCards()
    }
    
    public func isFocusedWinner() -> Bool {
        let curCanvas = canvasCard
        if newCanvas != nil {
            canvasCard = newCanvas!
        }
        if newPalette != nil {
            playerStates[playerTurn].addPaletteCard(card: newPalette!)
        }
        
        let comp = compareStates(first: playerStates[playerTurn], second: playerStates[1 - playerTurn], canvasColor: canvasCard.getColor())
        
        if newCanvas != nil {
            canvasCard = curCanvas
        }
        if newPalette != nil {
            playerStates[playerTurn].removePaletteCard()
        }
        
        return comp == 1
    }
    
    public func endTurn() {
        if newCanvas != nil {
            canvasCard = newCanvas!
            playerStates[playerTurn].removeHandCard(card: newCanvas!)
        }
        if newPalette != nil {
            playerStates[playerTurn].addPaletteCard(card: newPalette!)
            playerStates[playerTurn].removeHandCard(card: newPalette!)
        }
        playerTurn = 1 - playerTurn
        newCanvas = nil
        newPalette = nil
    }
    
    public func updateCanvasCard(card: Card?) -> Bool {
        if card == nil {
            newCanvas = nil
            return false
        } else {
            if newCanvas == nil {
                newCanvas = card
                return false
            }
            newCanvas = card
            return true
        }
    }
    
    public func updatePaletteCard(card: Card?) -> Bool {
        if card == nil {
            newPalette = nil
            return false
        } else {
            if newPalette == nil {
                newPalette = card
                return false
            }
            newPalette = card
            return true
        }
    }
}
