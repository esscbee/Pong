//
//  GameScene.swift
//  Pong
//
//  Created by Stephen Brennan on 6/28/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.scaleMode = SKSceneScaleMode.ResizeFill
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        print(frame)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        return
        if let ball = childNodeWithName("//ball") {
            if let pb = ball.physicsBody {
                print(String(format:"%X", pb.categoryBitMask), " \(pb.velocity)")
                if let pb2 = physicsBody {
                    print(String(format:"%X", pb2.collisionBitMask), " ", frame)
                }
            }
        }
    }
    
    override func didChangeSize(oldSize: CGSize) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        
        
//        self.physicsBody?.friction = 0
        print("didChangeSize \(frame), size: \(size), \(physicsBody)")
    }
}
