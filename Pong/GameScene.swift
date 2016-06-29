//
//  GameScene.swift
//  Pong
//
//  Created by Stephen Brennan on 6/28/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel : SKLabelNode?
    
    var canScore = [ SKNode ] ()
    
    var score : Int = 0 {
        didSet {
            if let sl = scoreLabel {
                sl.text = String(score)
            }
        }
    }
    override func didMoveToView(view: SKView) {
        scoreLabel = self.childNodeWithName("//Score") as? SKLabelNode
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
                let nodeFrame = node.frame // CGRect(origin: nodePosition, size: node.frame.size)
//                print("touch")
//                print("  location: \(location)")
//                print("  nodeFrame: \(nodeFrame)")
                if(CGRectContainsPoint(nodeFrame, location)) {
                    node.physicsBody?.dynamic = false
                    self.touchPaddle = node as? SKSpriteNode
                } else if (node.position.y + node.frame.size.height) < location.y {
                    
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
        var toDelete = [ SKNode]()
        
        enumerateChildNodesWithName("//ball", usingBlock: {
            node, stop in
            
            let pb = node.physicsBody!
            let v = pb.velocity
            let mag = pow(v.dx*v.dx + v.dy*v.dy, 0.5)
            
            if false {
                let mul = mag / 800.0
                if mul < 1 {
                    pb.velocity = CGVector(dx: v.dx / mul, dy: v.dy / mul)
                }
            } else {
                
                let minDy : CGFloat = 500.0 + CGFloat(self.score) * 5.0
                if abs(v.dy) < minDy {
                    let sign : CGFloat = v.dy < 0 ? -1 : 1
                    pb.velocity = CGVector(dx:v.dx, dy: CGFloat(sign * minDy))
                }
            }
        })
        for b in toDelete {
            killBall(b)
        }
    }
    
    func killBall(b : SKNode) {
        b.parent!.parent!.removeFromParent()
        score -= 3
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
        var paddle : SKNode?
        
        for n in [contact.bodyA.node, contact.bodyB.node ] {
            if let s = n as? SKScene {
                scene = s
                ball = contact.bodyB.node
            } else if let s = n {
                if s.name == "ball" {
                    ball = s
                } else if s.name == "Paddle" {
                    paddle = s
                }
            }
        }
        if let _ = scene {
            if let b = ball {
                if let n = b.name {
                    if n == "ball" {
                        let idx = canScore.indexOf(b)
                        if idx == nil {
                            canScore.append(b)
                        }
                        if contact.contactPoint.y < 7 {
                            killBall(b)
//                            if false {
//                                print("didBeginContact")
//                                print("  A: \(contact.bodyA)")
//                                print("  B: \(contact.bodyB)")
//                                print("  contact: \(contact.contactPoint)")
//                            }
                        }
                    }
                }
            }
        } else if(canScore.count != 0) {
            if let b = ball {
                if let _ = paddle {
                    if let idx = canScore.indexOf(b) {
                        canScore.removeAtIndex(idx)
                        enumerateChildNodesWithName("//ball", usingBlock: {
                            node, stop in
                            self.score += 1
                        })
                    }
                }
            }
        }
    }
}
