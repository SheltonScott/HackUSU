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
    var playerHp = 0
    var warriorFrames = [SKTexture]()
    
    let rightArrow = SKSpriteNode(imageNamed: "right-arrow")
    let leftArrow = SKSpriteNode(imageNamed: "left-arrow")
    let jumpArrow = SKSpriteNode(imageNamed: "jump-arrow")
    
    let cam = SKCameraNode()
    
    var leftArrowPressed = false
    var rightArrowPressed = false
    var jumpArrowPressed = false
    
    let key = SKSpriteNode(imageNamed: "key")
    var numKeys = 0
    
    let monsterType = Int(arc4random_uniform(2))
    
    var blob = SKSpriteNode()
    var blobFrames = [SKTexture]()
    
    var zomb = SKSpriteNode()
    var zombFrames = [SKTexture]()
    
    let numBlobs = Int(arc4random_uniform(6 + 1))
    let numZombs = Int(arc4random_uniform(6 + 1))
    
    var blobX = CGFloat(200)
    var zombX = CGFloat(200)
    
    var touchingGround = false
    
    var keysLabel = SKLabelNode()
    
    enum CategoryMask: UInt32 {
        case warrior = 0b01 // 1
        case blob = 0b10 // 2
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        blobX = CGFloat(200)
        zombX = CGFloat(200)
        
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
        
        key.position = CGPoint(x: frame.midX + 1700, y: frame.midY + 200)
        key.zPosition = 1.0
        key.physicsBody = SKPhysicsBody(texture: key.texture!,
                                        size: key.texture!.size())
        key.physicsBody!.allowsRotation = false
        key.physicsBody!.restitution = 0.0
        key.name = "key"
        self.addChild(key)
        
        keysLabel.text = ("Keys: " + String(numKeys))
        keysLabel.fontColor = UIColor.black
        keysLabel.fontSize = 60.0
        keysLabel.fontName = "arial"
        keysLabel.zPosition = 2.0
        keysLabel.position = CGPoint(x: frame.midX - 480, y: frame.midY + 240)
        cam.addChild(keysLabel)
        
        switch monsterType {
        case 0:
            for _ in 0..<numBlobs {
                blob = SKSpriteNode(imageNamed: "blob0")
                blob.position = CGPoint(x: frame.midX + blobX, y: frame.midY + 500.0)
                blob.physicsBody = SKPhysicsBody(texture: blob.texture!,
                                                 size: blob.texture!.size())
                blob.physicsBody!.allowsRotation = false
                blob.physicsBody!.restitution = 0.0
                blob.name = "blob"
                
                self.addChild(blob)
                
                blobX += CGFloat(arc4random_uniform(300 + 100))
                
                let textureAtlas = SKTextureAtlas(named: "Blob")
                
                for index in 0..<textureAtlas.textureNames.count {
                    let textureName = "blob\(index).png"
                    blobFrames.append(textureAtlas.textureNamed(textureName))
                }
                blob.run(SKAction.repeatForever(SKAction.animate(with: blobFrames, timePerFrame: 0.08)))
            }
            break
        case 1:
            for _ in 0..<numZombs {
                zomb = SKSpriteNode(imageNamed: "zombie_idle_1")
                zomb.position = CGPoint(x: frame.midX + zombX, y: frame.midY + 500.0)
                zomb.physicsBody = SKPhysicsBody(texture: zomb.texture!,
                                                 size: zomb.texture!.size())
                zomb.physicsBody!.allowsRotation = false
                zomb.physicsBody!.restitution = 0.0
                zomb.name = "zomb"
                
                self.addChild(zomb)
                
                zombX += CGFloat(arc4random_uniform(300 + 100))
                
                let textureAtlas = SKTextureAtlas(named: "ZombieIdle")
                
                for index in 1..<textureAtlas.textureNames.count {
                    let textureName = "zombie_idle_\(index).png"
                    zombFrames.append(textureAtlas.textureNamed(textureName))
                }
                zomb.run(SKAction.repeatForever(SKAction.animate(with: zombFrames, timePerFrame: 0.08)))
            }
            break
        default:
            break
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
            nextScene!.playerHP = playerHp
            scene!.view?.presentScene(nextScene!, transition: transition)
            monster.removeFromParent()
        }
        if (monster.name == "zomb") {
            let transition = SKTransition.reveal(
                with: .down,
                duration: 1.0
            )
            
            let nextScene = Encounter(fileNamed: "Encounter")
            nextScene!.playerHP = playerHp
            nextScene!.scaleMode = .aspectFill
            nextScene?.type = 1
            scene!.view?.presentScene(nextScene!, transition: transition)
            
            monster.removeFromParent()
        }
        if (monster.name == "key") {
            
            monster.removeFromParent()
            print("collided")
            numKeys += 1
            
            
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
        if jumpArrow.contains(touch.location(in: cam)) {
            jumpArrowPressed = true
            if (warrior.position.y <= frame.midY + 200) {
            movePlayerUp(warrior)
            }
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
    
    func movePlayerUp(_ player: SKSpriteNode) {
        player.run(SKAction.moveBy(x: 0.0, y: 200.0, duration: 0.2))
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
        if jumpArrow.contains(touch.location(in: cam)) {
            jumpArrowPressed = false
        }
      
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        keysLabel.text = ("Keys: " + String(numKeys))
    }
}
