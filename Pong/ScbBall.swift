//
//  Ball.swift
//  Pong
//
//  Created by Stephen Brennan on 6/29/16.
//  Copyright © 2016 Stephen Brennan. All rights reserved.
//

import SpriteKit

class ScbBall : SKSpriteNode {
    
    let images = [
        "656099-glass-sphere-red-1",
        "656099-glass-sphere-red",
        "656099-glass-sphere-yellow-1",
        "656099-glass-sphere-yellow-2",
        "656099-glass-sphere-yellow",
        "656099-glass-sphere-fire",
        "656099-glass-sphere-firey-purple",
        "656099-glass-sphere-lavendar",
        "656099-glass-sphere-molton",
        "656099-glass-sphere-burnt",
        "656099-glass-sphere-normal",
        "656099-glass-sphere-orange-2",
        "656099-glass-sphere-orange",
        "656099-glass-sphere-poster-1",
        "656099-glass-sphere-purple",
        "656099-glass-sphere-blue-1",
        "656099-glass-sphere-blue-2",
        "656099-glass-sphere-blue-3",
        "656099-glass-sphere-blue-4",
        "656099-glass-sphere-blue-5",
        "656099-glass-sphere-blue-6",
        "656099-glass-sphere-clear",
        "ball",
    ]
    var isDead = false
    
    
    var pointValue : Int {
        get {
            return hits == 0 ? 1 : 3 * hits
        }
    }
    var hits = 0 {
        didSet {
            self.texture = SKTexture(imageNamed: images[hits % images.count])
        }
    }
    
    func gotPaddled() {
        hits += 1
    }
    
    func kill() {
        isDead = true
    }
    
    
}