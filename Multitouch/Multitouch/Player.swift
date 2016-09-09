//
//  Player.swift
//  Multitouch
//
//  Created by Sean Alling on 12/5/16.
//  Copyright © 2016 Alling Katz. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
  
  var health: Int
  var minerals: Int
  //  var workers: [Worker] = []
  //  var shields: Stack<Shield> = []
  var fireRange: CGVector
  var fireRate: TimeInterval
  var isShielded: Bool
  var preTouchedRotation: CGFloat = CGFloat(M_PI / 2)
  
  // TODO: set start positions, dynamic for health? (SBA)
  init(imageNamed: String) {
    self.health = 100
    self.minerals = 0
    self.fireRate = TimeInterval(0.5)
    self.isShielded = false
    self.fireRange = CGVector(dx: 150, dy: 0)
    let playerTexture = SKTexture(imageNamed: imageNamed)
    super.init(texture: playerTexture, color: SKColor.clear, size: playerTexture.size())
    self.zRotation = self.preTouchedRotation
    // NEED -- setup start position (SBA)
    // NEED -- dynamic color for health
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.health = 100
    self.minerals = 0
    self.fireRange = CGVector(dx: 150, dy: 150)
    self.fireRate = TimeInterval(0.5)
    self.isShielded = false
    super.init(coder: aDecoder)
  }
  
  // TODO: add interaction mechanism for shields / reference this? & terminat on shield expiration
  func shieldsUp() {
    //    if let thisShield = self.shields.pop() {
    self.isShielded = true
    // NEED -- Interaction / Collision mechanism
    // NEED -- Terminate when user touches OR when shield time is up
    //    }
  }
  
  // TODO: link to the actual firing mechanisms?
  func fire(_ toTarget: CGPoint) {
    // create a bullet
    // move bullet
    // remove bullet
  }
  
  func rotate(_ angle: CGFloat) {
    // roatates the sprite
    self.zRotation = angle - (CGFloat(M_PI) / 2)
  }
}
