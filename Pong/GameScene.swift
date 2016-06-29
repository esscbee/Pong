//
//  GameScene.swift
//  Pong
//
//  Created by Stephen Brennan on 6/28/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.scaleMode = SKSceneScaleMode.ResizeFill
        resetPhysics()
        print(frame)
    }
    
    var touchPaddle : SKSpriteNode?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let node = self.childNodeWithName("//Paddle") {
            for touch in touches {
                let location = touch.locationInNode(self)
                let nodePosition = self.convertPoint(node.position, fromNode: node)
                let nodeFrame = node.frame // CGRect(origin: nodePosition, size: node.frame.size)
//                print("touch")
//                print("  location: \(location)")
//                print("  nodeFrame: \(nodeFrame)")
                if(CGRectContainsPoint(nodeFrame, location)) {
                    node.physicsBody?.dynamic = false
                    self.touchPaddle = node as? SKSpriteNode
                } else {
                    // launch a ball
                    let resourcePath = NSBundle.mainBundle().pathForResource("Ball", ofType: "sks")
                    let newBall = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
                    newBall.position = location
                    self.addChild(newBall)

                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let tn = touchPaddle {
            if let t = touches.first {
                let location = t.locationInNode(self)
                tn.position = location
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchPaddle = nil
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
    
    func resetPhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.contactTestBitMask = 0xffffffff
    }
    
    override func didChangeSize(oldSize: CGSize) {
        resetPhysics()
        print("didChangeSize \(frame), size: \(size), \(physicsBody)")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var scene : SKNode?
        var ball : SKNode?
        
        if let s = contact.bodyA.node as? SKScene {
            scene = s
            ball = contact.bodyB.node
        } else if let s = contact.bodyB.node as? SKScene {
            scene = s
            ball = contact.bodyA.node
        }
        if let s = scene {
            if let b = ball {
                if let n = b.name {
                    if n == "ball" {
                        if contact.contactPoint.y < 5 {
                            b.parent!.parent!.removeFromParent()
                            print("didBeginContact")
                            print("  A: \(contact.bodyA)")
                            print("  B: \(contact.bodyB)")
                            print("  contact: \(contact.contactPoint)")
                        }
                    }
                }
            }
        }
    }
}
