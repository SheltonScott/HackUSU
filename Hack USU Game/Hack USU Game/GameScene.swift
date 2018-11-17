//
//  GameScene.swift
//  Hack USU Game
//
//  Created by scott shelton on 11/16/18.
//  Copyright © 2018 scott shelton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let warrior = SKSpriteNode(imageNamed: "warrior_right1")
    var warriorFrames = [SKTexture]()
    
    let rightArrow = SKSpriteNode(imageNamed: "right-arrow")
    let leftArrow = SKSpriteNode(imageNamed: "left-arrow")
    let jumpArrow = SKSpriteNode(imageNamed: "jump-arrow")
    
    let cam = SKCameraNode()
    
    var leftArrowPressed = false
    var rightArrowPressed = false
    var jumpArrowPressed = false
    
    var blob = SKSpriteNode()
    var blobFrames = [SKTexture]()
    
    let numBlobs = Int(arc4random_uniform(6 + 1))
    
    enum CategoryMask: UInt32 {
        case warrior = 0b01 // 1
        case blob = 0b10 // 2
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        for node in self.children {
            if (node.name == "TileMap") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        warrior.position = CGPoint(x: frame.midX, y: frame.midY)
        warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!,
                                            size: warrior.texture!.size())
        warrior.physicsBody!.allowsRotation = false
        warrior.physicsBody!.contactTestBitMask = warrior.physicsBody!.collisionBitMask
        warrior.physicsBody!.restitution = 0.0
        warrior.name = "warrior"
        
        self.addChild(warrior)
        
        self.camera = cam
        self.addChild(cam)
        
        rightArrow.position = CGPoint(x: warrior.position.x - 300 , y: warrior.position.y - 215)
        rightArrow.zPosition = 1.0
        cam.addChild(rightArrow)
        
        leftArrow.position = CGPoint(x:  warrior.position.x - 500 , y: warrior.position.y - 215)
        leftArrow.zPosition = 1.0
        cam.addChild(leftArrow)
        
        jumpArrow.position = CGPoint(x: warrior.position.x + 500, y: warrior.position.y - 215)
        jumpArrow.zPosition = 1.0
        cam.addChild(jumpArrow)
        
        let constraint = SKConstraint.distance(SKRange(constantValue: 0), to: warrior)
        cam.constraints = [constraint]
        
        for _ in 0..<numBlobs {
            blob = SKSpriteNode(imageNamed: "blob0")
            let randomBlobX = CGFloat(arc4random_uniform(2000 + 100))
            blob.position = CGPoint(x: frame.midX + randomBlobX, y: frame.midY)
            blob.physicsBody = SKPhysicsBody(texture: blob.texture!,
                                             size: blob.texture!.size())
            blob.physicsBody!.allowsRotation = false
            blob.physicsBody!.restitution = 0.0
            blob.name = "blob"
        
            self.addChild(blob)
            
            let textureAtlas = SKTextureAtlas(named: "Blob")
            
            for index in 0..<textureAtlas.textureNames.count {
                let textureName = "blob\(index).png"
                blobFrames.append(textureAtlas.textureNamed(textureName))
            }
            blob.run(SKAction.repeatForever(SKAction.animate(with: blobFrames, timePerFrame: 0.08)))
        }
        
        
    }
 
    func collision(_ player: SKSpriteNode,_ monster: SKSpriteNode) {
        if (monster.name == "blob") {
            let transition = SKTransition.reveal(
                with: .down,
                duration: 1.0
            )
            
            let nextScene = Encounter(fileNamed: "Encounter")
            nextScene!.scaleMode = .aspectFill
            
            scene!.view?.presentScene(nextScene!, transition: transition)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "warrior" {
            collision(contact.bodyA.node as! SKSpriteNode, contact.bodyB.node! as! SKSpriteNode)
        } else if contact.bodyB.node?.name == "warrior" {
            collision(contact.bodyB.node! as! SKSpriteNode, contact.bodyA.node! as! SKSpriteNode)
        }
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
        if leftArrow.contains(touch.location(in: cam)) {
            leftArrowPressed = true
            movePlayerLeft(warrior)
        }
        if rightArrow.contains(touch.location(in: cam)) {
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
        if leftArrow.contains(touch.location(in: cam)) {
            leftArrowPressed = false
        }
        if rightArrow.contains(touch.location(in: cam)) {
            rightArrowPressed = false
        }
      
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
