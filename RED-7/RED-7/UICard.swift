//
//  UICard.swift
//  RED-7
//
//  Created by Михаил Первеев on 21.12.2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import UIKit

class UICard: UIView {
    private var card: Card!
    private var dragGesture: UIPanGestureRecognizer!
    
    init(card: Card) {
        self.card = card
        
    }
}
