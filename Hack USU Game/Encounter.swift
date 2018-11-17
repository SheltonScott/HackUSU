//
//  Encounter.swift
//  Hack USU Game
//
//  Created by Alex  Cowley on 11/17/18.
//  Copyright © 2018 scott shelton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Encounter: SKScene {
    
    var type = 0
    let warrior = SKSpriteNode(imageNamed: "warrior_right_big1")
    let blob = SKSpriteNode(imageNamed: "blob_big0")
    let zomb = SKSpriteNode(imageNamed: "zombie_big")
    let giantZomb = SKSpriteNode(imageNamed: "zombie_giant")
    let attackButton = SKSpriteNode(imageNamed: "attack_button")
    var attackButtonPressed = false
    var monster = SKSpriteNode()
    var monsterHP = 0
    var monsterHpLabel = SKLabelNode()
    var playerHpLabel = SKLabelNode()
    var playerHP = 0
    var numKey = 0

    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        attackButton.position = CGPoint(x: frame.midX, y: frame.midY)
        attackButton.zPosition = 1.0
        self.addChild(attackButton)
        
        warrior.position = CGPoint(x: frame.midX - 350, y: frame.midY)
        warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!,
                                            size: warrior.texture!.size())
        warrior.physicsBody!.allowsRotation = false
        warrior.physicsBody!.contactTestBitMask = warrior.physicsBody!.collisionBitMask
        warrior.physicsBody!.restitution = 0.0
        warrior.name = "warrior"
        
        monsterHpLabel.text = (String(monsterHP) + " HP")
        monsterHpLabel.fontColor = UIColor.black
        monsterHpLabel.fontSize = 60.0
        monsterHpLabel.fontName = "arial"
        monsterHpLabel.zPosition = 2.0
        monsterHpLabel.position = CGPoint(x: frame.midX + 380, y: frame.midY + 250)
        self.addChild(monsterHpLabel)
        
        playerHpLabel.text = (String(playerHP) + " HP")
        playerHpLabel.fontColor = UIColor.black
        playerHpLabel.fontSize = 60.0
        playerHpLabel.fontName = "arial"
        playerHpLabel.zPosition = 2.0
        playerHpLabel.position = CGPoint(x: frame.midX - 380, y: frame.midY + 250)
        self.addChild(playerHpLabel)
        
        
        blob.position = CGPoint(x: frame.midX + 350, y: frame.midY)
        blob.physicsBody = SKPhysicsBody(texture: blob.texture!,
                                            size: blob.texture!.size())
        blob.physicsBody!.allowsRotation = false
        blob.physicsBody!.contactTestBitMask = blob.physicsBody!.collisionBitMask
        blob.physicsBody!.restitution = 0.0
        blob.name = "blob"
        
        zomb.position = CGPoint(x: frame.midX + 350, y: frame.midY)
        zomb.physicsBody = SKPhysicsBody(texture: zomb.texture!,
                                         size: zomb.texture!.size())
        zomb.physicsBody!.allowsRotation = false
        zomb.physicsBody!.contactTestBitMask = zomb.physicsBody!.collisionBitMask
        zomb.physicsBody!.restitution = 0.0
        zomb.name = "zomb"
        
        giantZomb.position = CGPoint(x: frame.midX + 350, y: frame.midY + 50)
        giantZomb.physicsBody = SKPhysicsBody(texture: giantZomb.texture!,
                                         size: giantZomb.texture!.size())
        giantZomb.physicsBody!.allowsRotation = false
        giantZomb.physicsBody!.contactTestBitMask = giantZomb.physicsBody!.collisionBitMask
        giantZomb.physicsBody!.restitution = 0.0
        giantZomb.name = "giantZomb"
        
        for node in self.children {
            if (node.name == "Tile Map Node") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        if (playerHP <= 0) {
            playerHP = 10
        }
        self.addChild(warrior)
        if (type == 0) {
            monster = blob
            monsterHP = 5
            self.addChild(monster)
        }
        if (type == 1) {
            monster = zomb
            monsterHP = 7
            self.addChild(monster)
        }
        if (type == 2) {
            monster = giantZomb
            monsterHP = 12
            self.addChild(monster)
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
    
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first!
    if attackButton.contains(touch.location(in: self)) {
        attackButtonPressed = true
        attackMonster(monster)
    }
}

    func attackMonster(_ monster: SKSpriteNode) {
    warrior.run(SKAction.sequence([SKAction.moveBy(x: 100.0, y: 0.0, duration: 0.08), SKAction.moveBy(x: -100.0, y: 0.0, duration: 0.08)]))
    if (monster.name == "blob") {
        monsterHP -= Int(arc4random_uniform(8 + 1))
        monster.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
        if (monsterHP <= 0) {
            monster.run(SKAction.moveBy(x: 0.0, y: -2000.0, duration: 0.45))
            let transition = SKTransition.reveal(
                with: .down,
                duration: 1.0
            )
            
            let nextScene = GameScene(fileNamed: "GameScene")
            nextScene!.numKeys = numKey
            nextScene!.playerHp = playerHP
            nextScene!.scaleMode = .aspectFill
            scene!.view?.presentScene(nextScene!, transition: transition)
        }
        if (monsterHP > 0) {
            monster.run(SKAction.sequence([SKAction.moveBy(x: -100.0, y: 0.0, duration: 0.08), SKAction.moveBy(x: 100.0, y: 0.0, duration: 0.08)]))
            warrior.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
            playerHP -= 1
        }
    }
    if (monster.name == "zomb") {
        monsterHP -= Int(arc4random_uniform(8 + 1))
        monster.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
        if (monsterHP <= 0) {
            monster.run(SKAction.moveBy(x: 0.0, y: -2000.0, duration: 0.45))
            let transition = SKTransition.reveal(
                with: .down,
                duration: 1.0
            )
            
            let nextScene = GameScene(fileNamed: "GameScene")
            nextScene!.numKeys = numKey
            nextScene!.playerHp = playerHP
            nextScene!.scaleMode = .aspectFill
            scene!.view?.presentScene(nextScene!, transition: transition)
        }
        if (monsterHP > 0) {
            monster.run(SKAction.sequence([SKAction.moveBy(x: -100.0, y: 0.0, duration: 0.08), SKAction.moveBy(x: 100.0, y: 0.0, duration: 0.08)]))
            warrior.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
            playerHP -= 1
        }
    }
        
        if (monster.name == "giantZomb") {
            monsterHP -= Int(arc4random_uniform(8 + 1))
            monster.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
            if (monsterHP <= 0) {
                monster.run(SKAction.moveBy(x: 0.0, y: -2000.0, duration: 0.45))
                let transition = SKTransition.reveal(
                    with: .down,
                    duration: 1.0
                )
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.numKeys = numKey + 1
                nextScene!.playerHp = playerHP
                nextScene!.scaleMode = .aspectFill
                scene!.view?.presentScene(nextScene!, transition: transition)
            }
            if (monsterHP > 0) {
                monster.run(SKAction.sequence([SKAction.moveBy(x: -100.0, y: 0.0, duration: 0.08), SKAction.moveBy(x: 100.0, y: 0.0, duration: 0.08)]))
                warrior.run(SKAction.sequence([SKAction.hide(), SKAction.unhide()]))
                playerHP -= 1
            }
        }
}

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if attackButton.contains(touch.location(in: self)) {
            attackButtonPressed = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        monsterHpLabel.text = (String(monsterHP) + " HP")
        playerHpLabel.text = (String(playerHP) + " HP")
        
    }
    

}
