//
//  GameViewController.swift
//  Pong
//
//  Created by Stephen Brennan on 6/28/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene : GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetGame()

    }
    func resetGame() {
        let skView = self.view as! SKView
        gameScene = GameScene(fileNamed:"GameScene")
        if let scene = gameScene {
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }

    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            resetGame()
        }
    }

}
