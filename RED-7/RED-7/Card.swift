//
//  Card.swift
//  RED-7
//
//  Created by Михаил Первеев on 05/10/2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import Foundation

enum Color: Int {
    
    case red = 7
    case orange = 6
    case yellow = 5
    case green = 4
    case blue = 3
    case navy = 2
    case purple = 1

}

struct Card: Equatable, Comparable, CustomStringConvertible {
    private var color: Color
    private var number: Int
    
    init(color: Color, number: Int) {
        self.color = color
        self.number = number
    }
    
    public func getColor() -> Color {
        return color
    }
    
    public func getNumber() -> Int {
        return number
    }
    
    public func isEqual(other: Card) -> Bool {
        return color == other.color && number == other.number
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.number < rhs.number || (lhs.number == rhs.number && lhs.color.rawValue < rhs.color.rawValue)
    }
    
    var description: String {
        return "Number: \(number), Color: \(color.rawValue)"
    }
}
