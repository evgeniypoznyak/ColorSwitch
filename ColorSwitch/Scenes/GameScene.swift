//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Evgeniy Poznyak on 6/24/20.
//  Copyright © 2020 Evgeniy Poznyak. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
        spawnBall()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
    }
    
    // MARK: Color Switch
    
    func layoutScene() {
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWeel()
    }
    
    func turnWeel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(score, forKey: "CurrentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view?.presentScene(menuScene)
        score = 0
    }
    
    
    
    // MARK: Fallign Ball
    
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0 // making sure colors are applyed to texture
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
}

// MARK: Delegates
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    print("Correct!")
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.score += 1
                        self.scoreLabel.text = String(self.score)
                        self.spawnBall()
                    }
                } else {
                    gameOver()
                    ball.removeFromParent()
                }
            }
        }
    }
    
}
