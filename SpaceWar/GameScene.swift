//
//  GameScene.swift
//  SpaceWar
//
//  Created by Иван Маришин on 01.10.2021.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    
    var spaceShip: SKSpriteNode!
    var score = 0
    var scoreLabel: SKLabelNode!
    var background: SKSpriteNode!
    var asteroidLayer: SKNode!
    var gameIsPause: Bool = false
    
    func onPauseGame() {
        gameIsPause = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
    }
    
    func offPauseGame() {
        gameIsPause = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
    }
    
    func resetGame() {
        self.score = 0
        self.scoreLabel.text = "Score: \(self.score)"
        
        gameIsPause = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
    }
    
    func pauseButton(sender: AnyObject) {
        if !gameIsPause {
            onPauseGame()
        }
        else {
            offPauseGame()
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.8)
        
        background = SKSpriteNode(imageNamed: "space")
        background.size = CGSize(width: frame.size.width+50, height: frame.size.height+50)
        addChild(background)
        
        spaceShip = SKSpriteNode(imageNamed: "spaceship")
        spaceShip.size = CGSize(width: 100, height: 100)
        spaceShip.position = CGPoint(x: 0, y: -500)
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        let colorAction1 = SKAction.colorize(with: .blue, colorBlendFactor: 1, duration: 1)
        let colorAction2 = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 1)
        
        let colorSeq = SKAction.sequence([colorAction1, colorAction2])
        let colorRep = SKAction.repeatForever(colorSeq)
        spaceShip.run(colorRep)
        
        addChild(spaceShip)
        
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.asteroidLayer.addChild(asteroid)
            asteroid.zPosition = 2
        }
        let asteroidCreateDelay = SKAction.wait(forDuration: 1.0, withRange: 0.5)
        let asteroidSeqAction = SKAction.sequence([asteroidCreate, asteroidCreateDelay])
        let asteroidCreateRepeat = SKAction.repeatForever(asteroidSeqAction)
        
        self.asteroidLayer.run(asteroidCreateRepeat)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: 0, y: (frame.size.height/2)-scoreLabel.frame.height-15)
        addChild(scoreLabel)
        
        background.zPosition = 0
        spaceShip.zPosition = 1
        scoreLabel.zPosition = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameIsPause {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                print(touchLocation)
                
                let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
                let speed: CGFloat = 800
                let time = timeTravelInterval(distance: distance, speed: speed)
                
                let moveAction = SKAction.move(to: touchLocation, duration: time)
                moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                spaceShip.run(moveAction)
                
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x/100, y: -touchLocation.y/100), duration: time)
                background.run(bgMoveAction)
                
            }
        }
    }
    
    func timeTravelInterval(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance/speed
        return TimeInterval(time)
    }
    
    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        let asteroidSize = Double.random(in: 30...150)
        asteroid.size = CGSize(width: asteroidSize, height: asteroidSize)
        
        asteroid.position.x = Double.random(in: -1...1)*((frame.size.width/2)-asteroid.size.width)
        asteroid.position.y = (frame.size.height/2) + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48()*2-1)*3
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48()*2-1)*100
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        //        let asteroid = createAsteroid()
        //        addChild(asteroid)
    }
    
    override func didSimulatePhysics() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { asteroid, stop in
            let hight = self.frame.size.height
            if asteroid.position.y < -hight {
                asteroid.removeFromParent()
                
                self.score = self.score+1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory || contact.bodyA.categoryBitMask == asteroidCategory && contact.bodyB.categoryBitMask == spaceShipCategory {
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
