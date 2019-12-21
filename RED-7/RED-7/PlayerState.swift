//
//  PlayerState.swift
//  RED-7
//
//  Created by Михаил Первеев on 17.12.2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import Foundation

class PlayerState {
    private var handCards: Array<Card>
    private var paletteCards: Array<Card>
    
    init(handCards: Array<Card>) {
        self.handCards = handCards
        self.paletteCards = Array<Card>()
    }
    
    func addPaletteCard(card: Card) {
        self.paletteCards.append(card)
    }
    
    public func addHandCard(card: Card) {
        self.handCards.append(card)
    }
    
    public func getHandCards() -> Array<Card> {
        return handCards
    }
    
    public func getPaletteCards() -> Array<Card> {
        return paletteCards
    }
}

func compareStates(first: PlayerState, second: PlayerState, canvasColor: Color) -> Int {
    switch canvasColor {
    case .blue:
        return compareBlueStates(first: first, second: second)
    case .green:
        return compareGreenStates(first: first, second: second)
    case .navy:
        return compareNavyStates(first: first, second: second)
    case .orange:
        return compareOrangeStates(first: first, second: second)
    case .purple:
        return comparePurpleStates(first: first, second: second)
    case .red:
        return compareRedStates(first: first, second: second)
    case .yellow:
        return compareYellowStates(first: first, second: second)
    }
}

func compareBlueStates(first: PlayerState, second: PlayerState) -> Int {
    var firstCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    var secondCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    
    for card in first.getPaletteCards() {
        firstCnt[card.getColor().rawValue].append(card)
    }
    for card in second.getPaletteCards() {
        secondCnt[card.getColor().rawValue].append(card)
    }
    
    let firstSum = firstCnt.filter { (cards) -> Bool in
        return !cards.isEmpty
    }.count
    let secondSum = secondCnt.filter { (cards) -> Bool in
        return !cards.isEmpty
    }.count
    
    if firstSum == secondSum {
        return compareRedStates(first: first, second: second)
    } else if firstSum > secondSum {
        return 1
    } else {
        return 2
    }
}

func compareGreenStates(first: PlayerState, second: PlayerState) -> Int {
    let firstEvenCards = first.getPaletteCards().filter { (card) -> Bool in
        return card.getNumber() % 2 == 0
    }
    let secondEvenCards = second.getPaletteCards().filter { (card) -> Bool in
        return card.getNumber() % 2 == 0
    }
    
    if firstEvenCards.isEmpty && secondEvenCards.isEmpty {
        return -1
    }
    
    if firstEvenCards.count == secondEvenCards.count {
        if firstEvenCards.max()! > secondEvenCards.max()! {
            return 1
        } else {
            return 2
        }
    } else if firstEvenCards.count > secondEvenCards.count {
        return 1
    } else {
        return 2
    }
}

func compareNavyStates(first: PlayerState, second: PlayerState) -> Int {
    var firstCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    var secondCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    
    for card in first.getPaletteCards() {
        firstCnt[card.getNumber()].append(card)
    }
    for card in second.getPaletteCards() {
        secondCnt[card.getNumber()].append(card)
    }
    
    var firstLen = 0
    var firstStart = 0
    for start in 1...7 {
        for end in start...7 {
            if firstCnt[end].isEmpty {
                break
            }
            
            if end - start + 1 >= firstLen {
                firstLen = end - start + 1
                firstStart = start
            }
        }
    }
    
    var secondLen = 0
    var secondStart = 0
    for start in 1...7 {
        for end in start...7 {
            if secondCnt[end].isEmpty {
                break
            }
            
            if end - start + 1 >= secondLen {
                secondLen = end - start + 1
                secondStart = start
            }
        }
    }
    
    if firstLen > secondLen {
        return 1
    }
    if firstLen < secondLen {
        return 2
    }
    
    let firstMax = firstCnt[firstStart + firstLen - 1].max()!
    let secondMax = secondCnt[secondStart + secondLen - 1].max()!
    
    if firstMax > secondMax {
        return 1
    } else {
        return 2
    }
}

func compareOrangeStates(first: PlayerState, second: PlayerState) -> Int {
    var firstCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    var secondCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    
    for card in first.getPaletteCards() {
        firstCnt[card.getNumber()].append(card)
    }
    for card in second.getPaletteCards() {
        secondCnt[card.getNumber()].append(card)
    }
    
    let firstMax = firstCnt.map { (cards) -> Int in
        return cards.count
    }.max()!
    let secondMax = secondCnt.map { (cards) -> Int in
        return cards.count
    }.max()!
    
    if firstMax > secondMax {
        return 1
    }
    if firstMax < secondMax {
        return 2
    }
    
    let firstMaxCard = firstCnt.filter { (cards) -> Bool in
        return cards.count == firstMax
    }.map { (cards) -> Card in
        return cards.max()!
    }.max()!
    let secondMaxCard = secondCnt.filter { (cards) -> Bool in
        return cards.count == secondMax
    }.map { (cards) -> Card in
        return cards.max()!
    }.max()!
    
    if firstMaxCard > secondMaxCard {
        return 1
    } else {
        return 2
    }
}

func comparePurpleStates(first: PlayerState, second: PlayerState) -> Int {
    let firstSmallCards = first.getPaletteCards().filter { (card) -> Bool in
        return card.getNumber() < 4
    }
    let secondSmallCards = second.getPaletteCards().filter { (card) -> Bool in
        return card.getNumber() < 4
    }
    
    if firstSmallCards.isEmpty && secondSmallCards.isEmpty {
        return -1
    }
    
    if firstSmallCards.count == secondSmallCards.count {
        if firstSmallCards.max()! > secondSmallCards.max()! {
            return 1
        } else {
            return 2
        }
    } else if firstSmallCards.count > secondSmallCards.count {
        return 1
    } else {
        return 2
    }
}

func compareRedStates(first: PlayerState, second: PlayerState) -> Int {
    if first.getPaletteCards().max()! > second.getPaletteCards().max()! {
        return 1
    } else {
        return 2
    }
}

func compareYellowStates(first: PlayerState, second: PlayerState) -> Int {
    var firstCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    var secondCnt = Array<Array<Card>>(repeating: Array<Card>(), count: 8)
    
    for card in first.getPaletteCards() {
        firstCnt[card.getColor().rawValue].append(card)
    }
    for card in second.getPaletteCards() {
        secondCnt[card.getColor().rawValue].append(card)
    }
    
    let firstMax = firstCnt.map { (cards) -> Int in
        return cards.count
    }.max()!
    let secondMax = secondCnt.map { (cards) -> Int in
        return cards.count
    }.max()!
    
    if firstMax > secondMax {
        return 1
    }
    if firstMax < secondMax {
        return 2
    }
    
    let firstMaxCard = firstCnt.filter { (cards) -> Bool in
        return cards.count == firstMax
    }.map { (cards) -> Card in
        return cards.max()!
    }.max()!
    let secondMaxCard = secondCnt.filter { (cards) -> Bool in
        return cards.count == secondMax
    }.map { (cards) -> Card in
        return cards.max()!
    }.max()!
    
    if firstMaxCard > secondMaxCard {
        return 1
    } else {
        return 2
    }
}
