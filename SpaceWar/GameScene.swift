//
//  GameScene.swift
//  SpaceWar
//
//  Created by Иван Маришин on 01.10.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "space")
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        addChild(background)
        
        spaceShip = SKSpriteNode(imageNamed: "spaceship")
        spaceShip.size = CGSize(width: 100, height: 100)
        spaceShip.position = CGPoint(x: 0, y: -500)
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        addChild(spaceShip)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        let asteroidCreateDelay = SKAction.wait(forDuration: 1.0, withRange: 0.5)
        let asteroidSeqAction = SKAction.sequence([asteroidCreate, asteroidCreateDelay])
        let asteroidCreateRepeat = SKAction.repeatForever(asteroidSeqAction)
        
        run(asteroidCreateRepeat)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            print(touchLocation)
            
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeTravelInterval(distance: distance, speed: speed)
            
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            spaceShip.run(moveAction)
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
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
//        let asteroid = createAsteroid()
//        addChild(asteroid)
    }
}
