//
//  GameScene.swift
//  Hack USU Game
//
//  Created by scott shelton on 11/16/18.
//  Copyright © 2018 scott shelton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let warrior = SKSpriteNode(imageNamed: "warrior_right0")
    let warriorFrames = [SKTexture]()
    
    override func didMove(to view: SKView) {
        warrior.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(warrior)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
