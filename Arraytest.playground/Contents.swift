//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
var projArray = [SKSpriteNode]()
let player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
for x in 1...10 {
    projArray.append(player)

}
print(projArray[0])