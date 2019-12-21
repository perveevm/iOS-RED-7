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
    private var defaultCenter: CGPoint!
    private var controllerView: UIView!
    
    var beginChangeState: (UICard, UIView?) -> Void
    var endChangeState: (UICard, UIView?) -> Void
    var simpleChangedPosition: (UICard, UIView?, Bool) -> Void
        
    init(card: Card, frame: CGRect, canDrag: Bool, controllerView: UIView, beginChangeState: @escaping (UICard, UIView?) -> Void, endChangeState: @escaping (UICard, UIView?) -> Void, simpleChangedPosition: @escaping (UICard, UIView?, Bool) -> Void) {
        self.beginChangeState = beginChangeState
        self.endChangeState = endChangeState
        self.simpleChangedPosition = simpleChangedPosition
        
        super.init(frame: frame)
        
        // Initialising fields
        self.card = card
        self.dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragged(dragGesture:)))
        self.defaultCenter = self.center
        self.controllerView = controllerView
        
        // Adding color to card
        switch card.getColor() {
        case .blue:
            self.backgroundColor = UIColor(red: 85.0 / 255.0, green: 184.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)
        case .green:
            self.backgroundColor = UIColor(red: 176.0 / 255.0, green: 203.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        case .navy:
            self.backgroundColor = UIColor(red: 42.0 / 255.0, green: 106.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
        case .orange:
            self.backgroundColor = UIColor(red: 227.0 / 255.0, green: 128.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
        case .purple:
            self.backgroundColor = UIColor(red: 96.0 / 255.0, green: 62.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
        case .red:
            self.backgroundColor = UIColor(red: 213.0 / 255.0, green: 55.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
        case .yellow:
            self.backgroundColor = UIColor(red: 243.0 / 255.0, green: 186.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
        }
        
        self.layer.cornerRadius = self.frame.width * 0.15
        self.clipsToBounds = true
        
        // Adding text to card
        let text = UILabel()
        
        text.text = String(card.getNumber())
        text.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        text.textColor = .white
        text.font = .systemFont(ofSize: self.frame.width)
        text.textAlignment = .center
        text.backgroundColor = .clear

        self.addSubview(text)
        
        // Interaction settings
        self.isUserInteractionEnabled = canDrag
        self.addGestureRecognizer(dragGesture)
    }
    
    @objc private func dragged(dragGesture: UIPanGestureRecognizer) {
        switch dragGesture.state {
        case .began:
            var translation = dragGesture.translation(in: self.superview)
            translation.x += self.center.x
            translation.y += self.center.y
            
            UIView.animate(withDuration: 0.1) {
                self.center = translation
                self.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 32.0))
            }
            
            dragGesture.setTranslation(CGPoint.zero, in: self.superview)
        case .changed:
            var translation = dragGesture.translation(in: self.superview)
            translation.x += self.center.x
            translation.y += self.center.y
            
            self.center = translation
            
            dragGesture.setTranslation(CGPoint.zero, in: self.superview)
            
            for subview in controllerView.subviews {
                if subview.point(inside: dragGesture.location(in: subview), with: nil) {
                    simpleChangedPosition(self, subview, true)
//                    break
                } else {
                    simpleChangedPosition(self, subview, false)
                }
            }
        case .ended:
            var destination: UIView?
            
            for subview in controllerView.subviews {
                if subview.point(inside: dragGesture.location(in: subview), with: nil) {
                    destination = subview
                }
                simpleChangedPosition(self, subview, false)
            }
            
            // TODO: find destination
            
            beginChangeState(self, destination)
            endChangeState(self, destination)
        default:
            ()
        }
        
        if (dragGesture.state == .ended) {
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.init(rotationAngle: CGFloat.zero)
            }
        }
    }
    
    public func getCard() -> Card {
        return self.card
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
