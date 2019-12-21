//
//  GameSceneViewController.swift
//  RED-7
//
//  Created by Михаил Первеев on 17.12.2019.
//  Copyright © 2019 com.perveev.mike. All rights reserved.
//

import UIKit

class GameSceneViewController: UIViewController {
    private var gameState: GameState!
    
    private var focusedPlayerHand: UIView!
    private var focusedPlayerPalette: UIView!
    private var canvas: UIView!
    private var otherPlayerHand: UIView!
    private var otherPlayerPalette: UIView!
    private var endTurnButton: UIButton!
    
    private var playersCount = 2
    private var PHI = 1.618
    private var NORM_COEFFICIENT = 3.5
    private var CARD_WIDTH = 0.0
    private var CARD_HEIGHT = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameState = GameState(playersCount: self.playersCount)
        
        canvas = UIView()
        focusedPlayerPalette = UIView()
        otherPlayerPalette = UIView()
        focusedPlayerHand = UIView()
        endTurnButton = UIButton()
        
        let coef = Double(self.view.frame.height) / NORM_COEFFICIENT
        CARD_WIDTH = coef / PHI
        CARD_HEIGHT = coef
        
        self.view.addSubview(canvas)
        self.view.addSubview(focusedPlayerPalette)
        self.view.addSubview(otherPlayerPalette)
        self.view.addSubview(endTurnButton)
        self.view.addSubview(focusedPlayerHand)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let coef = Double(self.view.frame.height) / NORM_COEFFICIENT
        let canvasHeight = coef
        let canvasWidth = coef / PHI
        
        canvas.backgroundColor = .black
        canvas.frame = CGRect(x: Double(self.view.frame.width * 0.7) + Double(self.view.frame.width * 0.15), y: Double(self.view.center.y) - canvasHeight / 2.0, width: canvasWidth, height: canvasHeight)
        
        focusedPlayerPalette.backgroundColor = .black
        focusedPlayerPalette.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height / 2.0) - canvasHeight / 2.0, width: Double(self.view.frame.width * 0.7), height: canvasHeight)
        
        otherPlayerPalette.backgroundColor = .black
        otherPlayerPalette.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight, width: Double(self.view.frame.width * 0.7), height: canvasHeight)
    
        focusedPlayerHand.backgroundColor = .black
        focusedPlayerHand.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height * (2.0 / 3.0)), width: Double(self.view.frame.width * 0.7), height: canvasHeight)
        
        addCardToCanvas(card: UICard(card: gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: coef / PHI, height: coef), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
//        canvas.addSubview(UICard(card: gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: coef / PHI, height: coef), canDrag: false, controllerView: self.view))
        focusedPlayerPalette.addSubview(UICard(card: gameState.getFocusedPaletteCards()[0], frame: CGRect(x: Double(focusedPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        otherPlayerPalette.addSubview(UICard(card: gameState.getOtherPaletteCards()[0], frame: CGRect(x: Double(otherPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        
        endTurnButton.frame = CGRect(x: Double(self.view.frame.width * 0.7) + Double(self.view.frame.width * 0.15), y: Double(self.view.frame.height * (2.0 / 3.0)), width: canvasWidth, height: 30)
        endTurnButton.backgroundColor = .black
        endTurnButton.addTarget(self, action: #selector(endTurn), for: .touchUpInside)
        endTurnButton.setTitle("Завершить ход", for: .normal)
        
        let focusedHandCards = gameState.getFocusedHandCards()
        for card in focusedHandCards {
            addCardToHand(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        }
//        for i in 0...focusedHandCards.count - 1 {
//            let currentX = Double(focusedPlayerHand.frame.width) / Double(focusedHandCards.count + 1) * Double(i + 1) - CARD_WIDTH / 2.0
//
//            focusedPlayerHand.addSubview(UICard(card: focusedHandCards[i], frame: CGRect(x: currentX, y: 0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view))
//        }
    }
    
    @objc private func endTurn() {
        if !gameState.isFocusedWinner() {
            let alert = UIAlertController(title: "Некорректный ход", message: "Вы не лидируете по текущему признаку", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Ход завершен", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        gameState.endTurn()
        
        canvas.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        focusedPlayerHand.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        focusedPlayerPalette.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        otherPlayerPalette.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        addCardToCanvas(card: UICard(card: gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        
        let focusedHandCards = gameState.getFocusedHandCards()
        for card in focusedHandCards {
            addCardToHand(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        }
        
        let focusedPaletteCards = gameState.getFocusedPaletteCards()
        for card in focusedPaletteCards {
            addCardToPalette(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        }
        
        let otherPaletteCards = gameState.getOtherPaletteCards()
        for card in otherPaletteCards {
            addCardToOtherPalette(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState))
        }
    }
    
    private func addCardToCanvas(card: UICard) {
        canvas.addSubview(card)
        UIView.animate(withDuration: 0.5) {
            card.center = CGPoint(x: self.canvas.frame.width / 2.0, y: self.canvas.frame.height / 2.0)
        }
    }
    
    private func removeLastCardFromCanvas(card: UICard) {
        card.removeFromSuperview()
//        canvas.subviews[canvas.subviews.count - 1].removeFromSuperview()
    }
    
    private func relayoutCards(view: UIView) {
        let cardsNumber = view.subviews.count
        for i in 0...cardsNumber - 1 {
            let currentX = Double(view.frame.width) / Double(cardsNumber + 1) * Double(i + 1)
            
            UIView.animate(withDuration: 0.5) {
                view.subviews[i].center.x = CGFloat(currentX)
                view.subviews[i].center.y = view.frame.height / 2.0
            }
        }
    }
    
    private func addCardToHand(card: UICard) {
        focusedPlayerHand.addSubview(card)
        relayoutCards(view: focusedPlayerHand)
    }
    
    private func removeCardFromHand(card: UICard) {
        print(focusedPlayerHand.subviews.count)
        card.removeFromSuperview()
        print(focusedPlayerHand.subviews.count)
        relayoutCards(view: focusedPlayerHand)
    }
    
    private func addCardToPalette(card: UICard) {
        print(focusedPlayerPalette.subviews.count)
        focusedPlayerPalette.addSubview(card)
        print(focusedPlayerPalette.subviews.count)
        relayoutCards(view: focusedPlayerPalette)
    }
    
    private func addCardToOtherPalette(card: UICard) {
        otherPlayerPalette.addSubview(card)
        relayoutCards(view: otherPlayerPalette)
    }
    
    private func removeCardFromPalette(card: UICard) {
        card.removeFromSuperview()
        relayoutCards(view: focusedPlayerPalette)
    }
    
    private func beginChangeState(card: UICard, destination: UIView?) {
        if card.superview!.isEqual(canvas) {
            gameState.updateCanvasCard(card: nil)
            removeLastCardFromCanvas(card: card)
        } else if card.superview!.isEqual(focusedPlayerPalette) {
            gameState.updatePaletteCard(card: nil)
            removeCardFromPalette(card: card)
        } else {
            removeCardFromHand(card: card)
        }
        
//        self.view.addSubview(card)
//        self.view.bringSubviewToFront(card)
    }
    
    private func endChangeState(card: UICard, destination: UIView?) {
        if destination == nil {
            addCardToHand(card: card)
        } else {
            if destination!.isEqual(canvas) {
                let needErase = gameState.updateCanvasCard(card: card.getCard())
                
                if needErase {
                    let erasedCard = canvas.subviews.last! as! UICard
                    removeLastCardFromCanvas(card: erasedCard)
                    addCardToHand(card: erasedCard)
                }
    
                addCardToCanvas(card: card)
            } else if destination!.isEqual(focusedPlayerPalette) {
                let needErase = gameState.updatePaletteCard(card: card.getCard())
                
                if needErase {
                    let eraseCard = focusedPlayerPalette.subviews.last! as! UICard
                    removeCardFromPalette(card: eraseCard)
                    addCardToHand(card: eraseCard)
                }
                
                addCardToPalette(card: card)
            } else {
                addCardToHand(card: card)
            }
        }
        print("kek")
    }
}
