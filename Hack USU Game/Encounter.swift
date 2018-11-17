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
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        warrior.position = CGPoint(x: frame.midX - 350, y: frame.midY)
        warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!,
                                            size: warrior.texture!.size())
        warrior.physicsBody!.allowsRotation = false
        warrior.physicsBody!.contactTestBitMask = warrior.physicsBody!.collisionBitMask
        warrior.physicsBody!.restitution = 0.0
        warrior.name = "warrior"
        
        
        blob.position = CGPoint(x: frame.midX + 350, y: frame.midY)
        blob.physicsBody = SKPhysicsBody(texture: blob.texture!,
                                            size: blob.texture!.size())
        blob.physicsBody!.allowsRotation = false
        blob.physicsBody!.contactTestBitMask = blob.physicsBody!.collisionBitMask
        blob.physicsBody!.restitution = 0.0
        blob.name = "blob"
        
        for node in self.children {
            if (node.name == "Tile Map Node") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(map: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        self.addChild(warrior)
        self.addChild(blob)
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
        
    }
func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
func update(_ currentTime: TimeInterval) {
        
    }
    

