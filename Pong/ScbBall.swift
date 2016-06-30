//
//  Ball.swift
//  Pong
//
//  Created by Stephen Brennan on 6/29/16.
//  Copyright © 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class ScbBall : SKSpriteNode {
    
    static let images = [
        SKTexture(imageNamed:"656099-glass-sphere-red-1"),
        SKTexture(imageNamed:"656099-glass-sphere-red"),
        SKTexture(imageNamed:"656099-glass-sphere-yellow-1"),
        SKTexture(imageNamed:"656099-glass-sphere-yellow-2"),
        SKTexture(imageNamed:"656099-glass-sphere-yellow"),
        SKTexture(imageNamed:"656099-glass-sphere-fire"),
        SKTexture(imageNamed:"656099-glass-sphere-firey-purple"),
        SKTexture(imageNamed:"656099-glass-sphere-lavendar"),
        SKTexture(imageNamed:"656099-glass-sphere-molton"),
        SKTexture(imageNamed:"656099-glass-sphere-burnt"),
        SKTexture(imageNamed:"656099-glass-sphere-normal"),
        SKTexture(imageNamed:"656099-glass-sphere-orange-2"),
        SKTexture(imageNamed:"656099-glass-sphere-orange"),
        SKTexture(imageNamed:"656099-glass-sphere-poster-1"),
        SKTexture(imageNamed:"656099-glass-sphere-purple"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-1"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-2"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-3"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-4"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-5"),
        SKTexture(imageNamed:"656099-glass-sphere-blue-6"),
        SKTexture(imageNamed:"656099-glass-sphere-clear"),
        SKTexture(imageNamed:"ball"),
    ]
    var isDead = false
    
    
    var pointValue : Int {
        get {
            return hits == 0 ? 1 : 3 * hits
        }
    }
    var hits = 0 {
        didSet {
            self.texture =  ScbBall.images[hits % ScbBall.images.count]
            if let pb = self.physicsBody {
                pb.mass *= 1.05
            }
        }
    }
    
    func gotPaddled() {
        hits += 1
    }
    
    func kill() {
        isDead = true
    }
    
    
}