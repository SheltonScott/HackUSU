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
    var warriorFrames = [SKTexture]()
    
    let rightArrow = SKSpriteNode(imageNamed: "right-arrow")
    let leftArrow = SKSpriteNode(imageNamed: "left-arrow")
    
    var leftArrowPressed = false
    var rightArrowPressed = false
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        for node in self.children {
            if (node.name == "TileMap") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        warrior.position = CGPoint(x: frame.midX, y: frame.midY)
        warrior.physicsBody = SKPhysicsBody(rectangleOf: warrior.size)
        warrior.physicsBody!.allowsRotation = false
        warrior.physicsBody!.restitution = 0.0
        
        self.addChild(warrior)
        
        rightArrow.position = CGPoint(x: frame.midX - 300, y: frame.midY - 215)
        rightArrow.zPosition = 1.0
        self.addChild(rightArrow)
        
        leftArrow.position = CGPoint(x: frame.midX - 500, y: frame.midY - 215)
        leftArrow.zPosition = 1.0
        self.addChild(leftArrow)
        
        
    }
    
    func giveTileMapPhysicsBody(map: SKTileMapNode) {
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    let tileArray = tileDefinition.textures
                    
                    let tileTexture = tileArray[0]
                    
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    let tileNode = SKSpriteNode(texture:tileTexture)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: (tileTexture.size().width), height: (tileTexture.size().height)))
                    tileNode.physicsBody?.linearDamping = 60.0
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.friction = 1
                    self.addChild(tileNode)
                    
                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                }
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        if leftArrow.contains(touch.location(in: self)) {
            leftArrowPressed = true
            movePlayerLeft(warrior)
        }
        if rightArrow.contains(touch.location(in: self)) {
            rightArrowPressed = true
            movePlayerRight(warrior)
        }
    }
    
    func movePlayerLeft(_ player: SKSpriteNode) {
        let textureAtlas = SKTextureAtlas(named: "WarriorLeft")
        
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "warrior_left\(index).png"
            warriorFrames.append(textureAtlas.textureNamed(textureName))
        }
        
        let move = SKAction.moveBy(x: -100.0, y: 0.0, duration: 0.2)
        let animate = SKAction.animate(with: warriorFrames, timePerFrame: 0.09)
        let group = SKAction.group([move, animate])
        player.run(group)
    }

    func movePlayerRight(_ player: SKSpriteNode) {
        
        let textureAtlas = SKTextureAtlas(named: "WarriorRight")
        
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "warrior_right\(index).png"
            warriorFrames.append(textureAtlas.textureNamed(textureName))
        }
        
        let move = SKAction.moveBy(x: 100.0, y: 0.0, duration: 0.2)
        let animate = SKAction.animate(with: warriorFrames, timePerFrame: 0.09)
        let group = SKAction.group([move, animate])
        player.run(group)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        warriorFrames.removeAll()
        let touch = touches.first!
        if leftArrow.contains(touch.location(in: self)) {
            leftArrowPressed = false
        }
        if rightArrow.contains(touch.location(in: self)) {
            rightArrowPressed = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        if (leftArrowPressed == true) {
//            movePlayerLeft(warrior)
//        }
//        if (rightArrowPressed == true) {
//            movePlayerRight(warrior)
//        }
    }
}
