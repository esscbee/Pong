//
//  GameScene.swift
//  Pong
//
//  Created by Stephen Brennan on 6/28/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // some constants
    let BALL_NAME = "ball"
    
    var scoreLabel : SKLabelNode?
    
    var canScore = [ SKNode ] ()
    
    var paddleTouch = false
    
    var ballCount = 0
    
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
    
    var touchPaddle = [UITouch: SKSpriteNode]()
    
    func launchBall(location : CGPoint) {
        // launch a ball
        let newBall = ScbBall(imageNamed: BALL_NAME)
        newBall.position = location
        newBall.name = BALL_NAME
        let theScale :CGFloat = 0.75
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
        
        ballCount += 1

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let node = self.childNodeWithName("//paddle") {
            for touch in touches {
                var location = touch.locationInNode(self)
                let nodeFrame = node.frame // CGRect(origin: nodePosition, size: node.frame.size)
//                print("touch")
//                print("  location: \(location)")
//                print("  nodeFrame: \(nodeFrame)")
                if(touchPaddle.isEmpty && CGRectContainsPoint(nodeFrame, location)) {
                    node.physicsBody?.dynamic = false
                    self.touchPaddle[touch] = node as? SKSpriteNode
                    paddleTouch = true
                }
                
                if (node.position.y + node.frame.size.height) < location.y {
                    location = CGPoint(x: location.x, y: node.position.y + node.frame.size.height + 100)
                }
                launchBall(location)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches {
            if let tn = touchPaddle[t] {
                paddleTouch = true
                if let t = touches.first {
                    let location = t.locationInNode(self)
                    tn.position = location
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches {
            touchPaddle[t] = nil
        }
    }
   

    override func update(currentTime: CFTimeInterval) {
        var toDelete = [ SKNode]()
        
        enumerateChildNodesWithName("//ball", usingBlock: {
            node, stop in
            
            
            
            let pb = node.physicsBody!
            var v = pb.velocity
            
            let n = node
            if true {
                let pt = n.position
                //                    print("ball position: \(pt)")
                if !CGRectContainsPoint(self.frame, pt) {
                    // print("toDelete - frame: \(self.frame), pt: \(pt)")
                    toDelete.append(node)
                } else {
                    
                    let minDy : CGFloat = 200.0 + CGFloat(self.score) * 0.1
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
        })
        for b in toDelete {
            killBall(b)
        }
    }
    
    func killBall(b : SKNode) {
        b.removeFromParent()
        score -= ballCount
        ballCount -= 1
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
        var ball : ScbBall?
        var paddle : SKNode?
        
        for n in [contact.bodyA.node, contact.bodyB.node ] {
            if let s = n as? SKScene {
                scene = s
            } else if let s = n {
                if let bb = s as? ScbBall {
//                    if let b = ball {
//                        killBall(b)
//                        killBall(s)
//                        return
//                    }
                    ball = bb
                } else if s.name == "paddle" {
                    paddle = s
                }
            }
        }
        if let _ = scene {
            if let b = ball {
                if let n = b.name {
                    if n == BALL_NAME {
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
        } else if(canScore.count != 0 && paddleTouch) {
            if let b = ball {
                if let _ = paddle {
                    if let idx = canScore.indexOf(b) {
                        canScore.removeAtIndex(idx)
                        b.gotPaddled()
                        self.score += ballCount * b.pointValue
                        paddleTouch = false
                    }
                }
            }
        }
    }
}
