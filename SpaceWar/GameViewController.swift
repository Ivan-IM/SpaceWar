//
//  GameViewController.swift
//  SpaceWar
//
//  Created by Иван Маришин on 01.10.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var pauseViewController: PauseViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        pauseViewController = storyboard?.instantiateViewController(withIdentifier: "PauseViewController") as! PauseViewController
        
        pauseViewController.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                gameScene = scene as! GameScene
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    
    func hidePauseScreen(vc: PauseViewController) {
        vc.willMove(toParent: nil)
        vc.removeFromParent()
        vc.view.removeFromSuperview()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        gameScene.pauseButton(sender: sender)
        
        present(pauseViewController, animated: true, completion: nil)
    }
    
    
}

extension GameViewController: PauseVCDelegate {
    func pauseVCPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(vc: pauseViewController)
    }
}
