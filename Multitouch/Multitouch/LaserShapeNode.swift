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
  let laserPath = CGMutablePath()
  
  
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
    
    self.laserPath.move(to: self.start)
    self.laserPath.addLine(to: self.end)
    
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
    let fadeAction = SKAction.fadeOut(withDuration: fadeDuration)
    
    let waitDuration = 0.25
    let waitAction = SKAction.wait(forDuration: waitDuration)
    
    let colorizeDuration = 1.25
    let colorizeAction = SKAction.colorize(with: UIColor("#0741ae"), colorBlendFactor: 1.0, duration: colorizeDuration)
    
    let actionSequence = SKAction.sequence([waitAction, fadeAction, SKAction.run({ self.removeFromParent() })])
    
    let actionGroup = SKAction.group([colorizeAction, actionSequence])
    
    self.run(actionGroup)
  }
}
