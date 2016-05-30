//
//  LaserShapeNode.swift
//  Multitouch
//
//  Created by Sean Alling on 27/5/16.
//  Copyright © 2016 Alling Katz. All rights reserved.
//

import Foundation
import SpriteKit


class LaserShapeNode: SKShapeNode {
  
  let start: CGPoint
  let end: CGPoint
  let laserPath = CGPathCreateMutable()
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //
  // init
  //
  init(_ start: CGPoint, _ end: CGPoint) {
    self.start = start
    self.end = end
    
    super.init()
    
    CGPathMoveToPoint(self.laserPath, nil, self.start.x, self.start.y)
    CGPathAddLineToPoint(self.laserPath, nil, self.end.x, self.end.y)
    
    self.path = self.laserPath
    
    self.lineWidth = 4.0
    self.fillColor = UIColor("#079dfb")
    self.strokeColor = UIColor("#079dfb")
  }
  
  //
  // Animate
  //
  func animate() {
    
    let fadeDuration = 1.0
    let fadeAction = SKAction.fadeOutWithDuration(fadeDuration)
    
    let waitDuration = 0.25
    let waitAction = SKAction.waitForDuration(waitDuration)
    
    let colorizeDuration = 1.25
    let colorizeAction = SKAction.colorizeWithColor(UIColor("#0741ae"), colorBlendFactor: 1.0, duration: colorizeDuration)
    
    let actionSequence = SKAction.sequence([waitAction, fadeAction, SKAction.runBlock({ self.removeFromParent() })])
    
    let actionGroup = SKAction.group([colorizeAction, actionSequence])
    
    self.runAction(actionGroup)
  }
}
