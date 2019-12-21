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
        
    init(card: Card, frame: CGRect, canDrag: Bool, controllerView: UIView, beginChangeState: @escaping (UICard, UIView?) -> Void, endChangeState: @escaping (UICard, UIView?) -> Void) {
        self.beginChangeState = beginChangeState
        self.endChangeState = endChangeState
        
        super.init(frame: frame)
        
        // Initialising fields
        self.card = card
        self.dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragged(dragGesture:)))
        self.defaultCenter = self.center
        self.controllerView = controllerView
        
        // Adding color to card
        switch card.getColor() {
        case .blue:
            self.backgroundColor = .cyan
        case .green:
            self.backgroundColor = .green
        case .navy:
            self.backgroundColor = .blue
        case .orange:
            self.backgroundColor = .orange
        case .purple:
            self.backgroundColor = .purple
        case .red:
            self.backgroundColor = .red
        case .yellow:
            self.backgroundColor = .yellow;
        }
        
        // Adding text to card
        let text = UILabel()
        
        text.text = String(card.getNumber())
        text.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
//        text.center = CGPoint
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
//            self.superview?.bringSubviewToFront(self)
            
//            controllerView.bringSubviewToFront(self.superview!)
//            controllerView.bringSubviewToFront(self)
            
//            if self.superview?.superview != nil {
//                self.superview?.superview?.bringSubviewToFront(self.superview!)
//            }
        case .changed:
//            self.superview?.bringSubviewToFront(self)
//            controllerView.bringSubviewToFront(self.superview!)
//            controllerView.bringSubviewToFront(self)
            var translation = dragGesture.translation(in: self.superview)
            translation.x += self.center.x
            translation.y += self.center.y
            
            self.center = translation
            
            dragGesture.setTranslation(CGPoint.zero, in: self.superview)
            
//            if (controllerView.subviews[1].point(inside: dragGesture.location(in: controllerView.subviews[1]), with: nil)) {
//                controllerView.subviews[1].backgroundColor = .red
//            } else {
//                controllerView.subviews[1].backgroundColor = .black
//            }
        case .ended:
            var destination: UIView?
            
            for subview in controllerView.subviews {
                if subview.point(inside: dragGesture.location(in: subview), with: nil) {
                    destination = subview
                }
            }
//
//            changeState(self, )
//
//            if controllerView.subviews[0].point(inside: dragGesture.location(in: controllerView.subviews[0]), with: nil) {
//                print("canvas")
//            } else if (controllerView.subviews[1].point(inside: dragGesture.location(in: controllerView.subviews[1]), with: nil)) {
//                controllerView.subviews[1].backgroundColor = .black
//                print("palette")
//            } else {
//                print("nothing")
//            }
            
            // TODO: find destination
            
            beginChangeState(self, destination)
            endChangeState(self, destination)
//            controllerView.subviews[1].backgroundColor = .black
            
//            if destination != nil {
//                changeState(self, destination!)
//            } else {
//                UIView.animate(withDuration: 0.5) {
//                    self.center = self.defaultCenter
//                }
//            }
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
