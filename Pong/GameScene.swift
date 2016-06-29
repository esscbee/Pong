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
    
    func launchBall(location : CGPoint) {
        // launch a ball
        let newBall = SKSpriteNode(imageNamed: "ball")
        newBall.position = location
        newBall.name = "ball"
        let theScale :CGFloat = 0.5
        newBall.xScale = theScale
        newBall.yScale = theScale
        let pb = SKPhysicsBody(circleOfRadius: newBall.size.width / 2.0)
        pb.affectedByGravity = false
        pb.mass = 1
        pb.friction = 0
        pb.angularDamping = 0
        pb.linearDamping = 0
        pb.restitution = 1
        pb.categoryBitMask = 0xffffffff
        pb.collisionBitMask = 0xffffffff
        pb.contactTestBitMask = 0xffffffff
        pb.velocity = CGVector( dx: random() % 200 - 100, dy: random() % 100 + 100)
        
        newBall.physicsBody = pb
        self.addChild(newBall)

    }
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
                    
                    launchBall(location)
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
            var v = pb.velocity
            let mag = pow(v.dx*v.dx + v.dy*v.dy, 0.5)
            
            if false {
                let mul = mag / 800.0
                if mul < 1 {
                    pb.velocity = CGVector(dx: v.dx / mul, dy: v.dy / mul)
                }
            } else {
                let n = node
                if true {
                    let pt = n.position
//                    print("ball position: \(pt)")
                    if !CGRectContainsPoint(self.frame, pt) {
                        // print("toDelete - frame: \(self.frame), pt: \(pt)")
                        toDelete.append(node)
                    } else {
                        
                        let minDy : CGFloat = 500.0 + CGFloat(self.score) * 5.0
                        if abs(v.dy) < minDy {
                            let sign : CGFloat = v.dy < 0 ? -1 : 1
                            v = CGVector(dx:v.dx, dy: CGFloat(sign * minDy))
                            pb.velocity = v
                        }
                        
                        let minDx = CGFloat(200.0)
                        if abs(v.dx) < minDx {
                            let sign : CGFloat = v.dy < 0 ? -1 : 1
                            pb.velocity = CGVector(dx: minDx * sign, dy: v.dy)
                        }}
                }
            }
        })
        for b in toDelete {
            killBall(b)
        }
    }
    
    func killBall(b : SKNode) {
        b.removeFromParent()
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
