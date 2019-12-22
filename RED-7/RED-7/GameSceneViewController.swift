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
    private var loseButton: UIButton!
    
    private var focusedPlayerLabelLeft: UILabel!
    private var focusedPlayerLabelRight: UILabel!
    private var otherPlayerLabelLeft: UILabel!
    private var otherPlayerLabelRight: UILabel!
    
    private var backgroundImage: UIImageView!
    
    private var playersCount = 2
    private var PHI = 1.618
    private var NORM_COEFFICIENT = 3.5
    private var CARD_WIDTH = 0.0
    private var CARD_HEIGHT = 0.0
    
    private var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
        gameState = GameState(playersCount: self.playersCount)
        
        canvas = UIView()
        focusedPlayerPalette = UIView()
        otherPlayerPalette = UIView()
        focusedPlayerHand = UIView()
        
        
        endTurnButton = UIButton()
        loseButton = UIButton()
        
        focusedPlayerLabelLeft = UILabel()
        focusedPlayerLabelRight = UILabel()
        otherPlayerLabelLeft = UILabel()
        otherPlayerLabelRight = UILabel()
        
        let coef = Double(self.view.frame.height) / NORM_COEFFICIENT
        CARD_WIDTH = coef / PHI
        CARD_HEIGHT = coef
        
        view.insertSubview(backgroundImage, at: 0)
        
        self.view.addSubview(focusedPlayerLabelLeft)
        self.view.addSubview(focusedPlayerLabelRight)
        self.view.addSubview(otherPlayerLabelLeft)
        self.view.addSubview(otherPlayerLabelRight)
        self.view.addSubview(canvas)
        self.view.addSubview(focusedPlayerPalette)
        self.view.addSubview(otherPlayerPalette)
        self.view.addSubview(endTurnButton)
        self.view.addSubview(loseButton)
        self.view.addSubview(focusedPlayerHand)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let canvasHeight = CARD_HEIGHT
        let canvasWidth = CARD_WIDTH
        
        // Set up background image
        backgroundImage.frame = view.bounds
        backgroundImage.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        
        // Layout canvas
        canvas.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.4)
        canvas.layer.cornerRadius = CGFloat(CARD_WIDTH * 0.15)
        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        canvas.frame = CGRect(x: Double(self.view.frame.width * 0.9) - canvasWidth / 2.0, y: Double(self.view.center.y) - canvasHeight / 2.0, width: canvasWidth, height: canvasHeight)

        // Layout palettes
        focusedPlayerPalette.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.4)
        focusedPlayerPalette.layer.cornerRadius = CGFloat(CARD_WIDTH * 0.15)
        focusedPlayerPalette.layer.borderWidth = 1
        focusedPlayerPalette.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        focusedPlayerPalette.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height / 2.0) - canvasHeight / 2.0, width: Double(self.view.frame.width * 0.7), height: canvasHeight)
        
        otherPlayerPalette.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.4)
        otherPlayerPalette.layer.cornerRadius = CGFloat(CARD_WIDTH * 0.15)
        otherPlayerPalette.layer.borderWidth = 1
        otherPlayerPalette.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        otherPlayerPalette.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight, width: Double(self.view.frame.width * 0.7), height: canvasHeight)
    
        // Layout hand
        focusedPlayerHand.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.4)
        focusedPlayerHand.layer.cornerRadius = CGFloat(CARD_WIDTH * 0.15)
        focusedPlayerHand.layer.borderWidth = 1
        focusedPlayerHand.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        focusedPlayerHand.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height * (2.0 / 3.0)), width: Double(self.view.frame.width * 0.7), height: canvasHeight)
        
        // Layout canvas card
        if firstLoad {
            addCardToCanvas(card: UICard(card: gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState, simpleChangedPosition: simpleChangedPosition))
        }
        
        // Layout palette cards
        if firstLoad {
            focusedPlayerPalette.addSubview(UICard(card: gameState.getFocusedPaletteCards()[0], frame: CGRect(x: Double(focusedPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState:         endChangeState, simpleChangedPosition: simpleChangedPosition))
            otherPlayerPalette.addSubview(UICard(card: gameState.getOtherPaletteCards()[0], frame: CGRect(x: Double(otherPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState, simpleChangedPosition: simpleChangedPosition))
        }
        
        // Layout buttons
        endTurnButton.frame = CGRect(x: Double(self.view.frame.width * 0.8) + Double(self.view.frame.width * 0.2 * 0.05), y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight, width: Double(self.view.frame.width * 0.2 * 0.9), height: canvasHeight / 3.0)
        endTurnButton.backgroundColor = UIColor(red: 176.0 / 255.0, green: 203.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        endTurnButton.addTarget(self, action: #selector(endTurn), for: .touchUpInside)
        endTurnButton.setTitle("Закончить ход", for: .normal)
        endTurnButton.layer.cornerRadius = endTurnButton.frame.height * 0.15
        endTurnButton.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        endTurnButton.layer.borderWidth = 1
        
        loseButton.frame = CGRect(x: Double(self.view.frame.width * 0.8) + Double(self.view.frame.width * 0.2 * 0.05), y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight / 3.0, width: Double(self.view.frame.width * 0.2 * 0.9), height: canvasHeight / 3.0)
        loseButton.backgroundColor = UIColor(red: 213.0 / 255.0, green: 55.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
        loseButton.addTarget(self, action: #selector(lose), for: .touchUpInside)
        loseButton.setTitle("Сдаться", for: .normal)
        loseButton.layer.cornerRadius = loseButton.frame.height * 0.15
        loseButton.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loseButton.layer.borderWidth = 1
        
        // Layout hand cards
        if firstLoad {
            let focusedHandCards = gameState.getFocusedHandCards()
            for card in focusedHandCards {
                addCardToHand(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: beginChangeState, endChangeState: endChangeState, simpleChangedPosition: simpleChangedPosition))
            }
        }
        
        focusedPlayerLabelLeft.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height / 2.0) - canvasHeight / 2.0, width: Double(self.view.frame.width * 0.7) / 2.0, height: canvasHeight)
        focusedPlayerLabelLeft.text = "Ваша"
        focusedPlayerLabelLeft.textAlignment = .center
        focusedPlayerLabelLeft.font = .systemFont(ofSize: focusedPlayerLabelLeft.frame.width / 10.0)
        
        focusedPlayerLabelRight.frame = CGRect(x: Double(self.view.frame.width * 0.1) + Double(self.view.frame.width * 0.7) / 2.0, y: Double(self.view.frame.height / 2.0) - canvasHeight / 2.0, width: Double(self.view.frame.width * 0.7) / 2.0, height: canvasHeight)
        focusedPlayerLabelRight.text = "палитра"
        focusedPlayerLabelRight.textAlignment = .center
        focusedPlayerLabelRight.font = .systemFont(ofSize: focusedPlayerLabelLeft.frame.width / 10.0)
        
        otherPlayerLabelLeft.frame = CGRect(x: Double(self.view.frame.width * 0.1), y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight, width: Double(self.view.frame.width * 0.7) / 2.0, height: canvasHeight)
        otherPlayerLabelLeft.text = "Палитра"
        otherPlayerLabelLeft.textAlignment = .center
        otherPlayerLabelLeft.font = .systemFont(ofSize: focusedPlayerLabelLeft.frame.width / 10.0)
        
        otherPlayerLabelRight.frame = CGRect(x: Double(self.view.frame.width * 0.1) + Double(self.view.frame.width * 0.7) / 2.0, y: Double(self.view.frame.height * (1.0 / 3.0)) - canvasHeight, width: Double(self.view.frame.width * 0.7) / 2.0, height: canvasHeight)
        otherPlayerLabelRight.text = "противника"
        otherPlayerLabelRight.textAlignment = .center
        otherPlayerLabelRight.font = .systemFont(ofSize: focusedPlayerLabelLeft.frame.width / 10.0)
        
        firstLoad = false
    }
    
    @objc private func endTurn() {
        if !gameState.isFocusedWinner() {
            let alert = UIAlertController(title: "Некорректный ход", message: "Вы не лидируете по текущему признаку", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Ход завершен", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (UIAlertAction) -> Void in
            self.gameState.endTurn()
            
            self.canvas.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            self.focusedPlayerHand.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            self.focusedPlayerPalette.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            self.otherPlayerPalette.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            
            self.addCardToCanvas(card: UICard(card: self.gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: self.CARD_WIDTH, height: self.CARD_HEIGHT), canDrag: false, controllerView: self.view, beginChangeState: self.beginChangeState, endChangeState: self.endChangeState, simpleChangedPosition: self.simpleChangedPosition))
            
            let focusedHandCards = self.gameState.getFocusedHandCards()
            for card in focusedHandCards {
                self.addCardToHand(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: self.CARD_WIDTH, height: self.CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: self.beginChangeState, endChangeState: self.endChangeState, simpleChangedPosition: self.simpleChangedPosition))
            }
            let focusedPaletteCards = self.gameState.getFocusedPaletteCards()
            for card in focusedPaletteCards {
                self.addCardToPalette(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: self.CARD_WIDTH, height: self.CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: self.beginChangeState, endChangeState: self.endChangeState, simpleChangedPosition: self.simpleChangedPosition))
            }
            
            let otherPaletteCards = self.gameState.getOtherPaletteCards()
            for card in otherPaletteCards {
                self.addCardToOtherPalette(card: UICard(card: card, frame: CGRect(x: 0.0, y: 0.0, width: self.CARD_WIDTH, height: self.CARD_HEIGHT), canDrag: true, controllerView: self.view, beginChangeState: self.beginChangeState, endChangeState: self.endChangeState, simpleChangedPosition: self.simpleChangedPosition))
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func lose() {
        let alert = UIAlertController(title: "Поражение", message: "Вы проиграли", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    private func addCardToCanvas(card: UICard) {
        card.center.x -= canvas.frame.minX
        card.center.y -= canvas.frame.minY
        canvas.addSubview(card)
        UIView.animate(withDuration: 0.5) {
            card.center = CGPoint(x: self.canvas.frame.width / 2.0, y: self.canvas.frame.height / 2.0)
        }
    }
    
    private func removeLastCardFromCanvas(card: UICard) {
        card.removeFromSuperview()
    }
    
    private func relayoutCards(view: UIView) {
        let cardsNumber = view.subviews.count
        let segmentWidth = Double(view.frame.width) / Double(cardsNumber + 1)
        
        for i in 0...cardsNumber - 1 {
            let currentX = segmentWidth * Double(i) + segmentWidth
            
            UIView.animate(withDuration: 0.5) {
                view.subviews[i].center.x = CGFloat(currentX)
                view.subviews[i].center.y = view.frame.height / 2.0
            }
        }
    }
    
    private func addCardToHand(card: UICard) {
        card.center.x -= focusedPlayerHand.frame.minX
        card.center.y -= focusedPlayerHand.frame.minY
        focusedPlayerHand.addSubview(card)
        relayoutCards(view: focusedPlayerHand)
    }
    
    private func removeCardFromHand(card: UICard) {
        card.removeFromSuperview()
        relayoutCards(view: focusedPlayerHand)
    }
    
    private func addCardToPalette(card: UICard) {
        card.center.x -= focusedPlayerPalette.frame.minX
        card.center.y -= focusedPlayerPalette.frame.minY
        focusedPlayerPalette.addSubview(card)
        relayoutCards(view: focusedPlayerPalette)
    }
    
    private func addCardToOtherPalette(card: UICard) {
        card.center.x -= otherPlayerPalette.frame.minX
        card.center.y -= otherPlayerPalette.frame.minY
        otherPlayerPalette.addSubview(card)
        relayoutCards(view: otherPlayerPalette)
    }
    
    private func removeCardFromPalette(card: UICard) {
        card.removeFromSuperview()
        relayoutCards(view: focusedPlayerPalette)
    }
    
    private func simpleChangedPosition(card: UICard, destination: UIView?, needColor: Bool) {
        if destination == nil {
            return
        }
        
        if needColor && (destination!.isEqual(canvas) || destination!.isEqual(focusedPlayerHand) || destination!.isEqual(focusedPlayerPalette)) {
            destination!.layer.borderColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            
            if !destination!.isEqual(canvas) {
                destination!.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.8)
            }
        } else if !needColor && (destination!.isEqual(canvas) || destination!.isEqual(focusedPlayerHand) || destination!.isEqual(focusedPlayerPalette)) {
            destination!.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            destination!.backgroundColor = UIColor(displayP3Red: 217.0 / 255.0, green: 101.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.4)
        }
    }
    
    private func beginChangeState(card: UICard, destination: UIView?) {
        if card.superview!.isEqual(canvas) {
            _ = gameState.updateCanvasCard(card: nil)
            removeLastCardFromCanvas(card: card)
            card.center.x += canvas.frame.minX
            card.center.y += canvas.frame.minY
            
            canvas.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if card.superview!.isEqual(focusedPlayerPalette) {
            _ = gameState.updatePaletteCard(card: nil)
            removeCardFromPalette(card: card)
            card.center.x += focusedPlayerPalette.frame.minX
            card.center.y += focusedPlayerPalette.frame.minY
            
            focusedPlayerPalette.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            removeCardFromHand(card: card)
            card.center.x += focusedPlayerHand.frame.minX
            card.center.y += focusedPlayerHand.frame.minY
            
            focusedPlayerHand.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
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
                    erasedCard.center.x += canvas.frame.minX
                    erasedCard.center.y += canvas.frame.minY
                    
                    addCardToHand(card: erasedCard)
                }
    
                addCardToCanvas(card: card)
            } else if destination!.isEqual(focusedPlayerPalette) {
                let needErase = gameState.updatePaletteCard(card: card.getCard())
                
                if needErase {
                    let erasedCard = focusedPlayerPalette.subviews.last! as! UICard
                    removeCardFromPalette(card: erasedCard)
                    erasedCard.center.x += focusedPlayerPalette.frame.minX
                    erasedCard.center.y += focusedPlayerPalette.frame.minY
                    
                    addCardToHand(card: erasedCard)
                }
                
                addCardToPalette(card: card)
            } else {
                addCardToHand(card: card)
            }
        }
    }
}
