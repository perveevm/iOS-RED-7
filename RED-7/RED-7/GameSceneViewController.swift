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
        
        let coef = Double(self.view.frame.height) / NORM_COEFFICIENT
        CARD_WIDTH = coef / PHI
        CARD_HEIGHT = coef
        
        self.view.addSubview(canvas)
        self.view.addSubview(focusedPlayerPalette)
        self.view.addSubview(otherPlayerPalette)
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
        
        canvas.addSubview(UICard(card: gameState.getCanvasCard(), frame: CGRect(x: 0.0, y: 0.0, width: coef / PHI, height: coef), canDrag: false, controllerView: self.view))
        focusedPlayerPalette.addSubview(UICard(card: gameState.getFocusedPaletteCards()[0], frame: CGRect(x: Double(focusedPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view))
        otherPlayerPalette.addSubview(UICard(card: gameState.getOtherPaletteCards()[0], frame: CGRect(x: Double(otherPlayerPalette.frame.width / 2.0) - CARD_WIDTH / 2.0, y: 0.0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: false, controllerView: self.view))
    
        let focusedHandCards = gameState.getFocuseddHandCards()
        for i in 0...focusedHandCards.count - 1 {
            let currentX = Double(focusedPlayerHand.frame.width) / Double(focusedHandCards.count + 1) * Double(i + 1) - CARD_WIDTH / 2.0
            
            focusedPlayerHand.addSubview(UICard(card: focusedHandCards[i], frame: CGRect(x: currentX, y: 0, width: CARD_WIDTH, height: CARD_HEIGHT), canDrag: true, controllerView: self.view))
        }
    }
}
