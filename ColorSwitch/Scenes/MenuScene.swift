//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Evgeniy Poznyak on 6/27/20.
//  Copyright © 2020 Evgeniy Poznyak. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        let logo =  SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.width/4, height: frame.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height / 4)
        addChild(logo)
    }
    
    func addLabels()  {
        
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.fontColor = .white
        animate(playLabel)
        addChild(playLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))")
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height * 4)
        highScoreLabel.fontColor = .white
        addChild(highScoreLabel)
        
        let currentScoreLabel = SKLabelNode(text: "Current Score: \(UserDefaults.standard.integer(forKey: "CurrentScore"))")
        currentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - currentScoreLabel.frame.size.height * 4)
        currentScoreLabel.fontColor = .white
        addChild(currentScoreLabel)
        
    }
    
    func animate(_ label: SKLabelNode) {
        //        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        //        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let zoomOut = SKAction.scale(to: 1.2, duration: 0.5)
        let zoomIn = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([zoomOut, zoomIn])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view?.presentScene(gameScene)
    }
    
}
