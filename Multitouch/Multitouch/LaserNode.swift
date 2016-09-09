//
//  LaserNode.swift
//  Multitouch
//
//  Created by Sean Alling on 16/5/16.
//  Copyright © 2016 Alling Katz. All rights reserved.
//

import Foundation
import SpriteKit



class LaserNode: SKShapeNode {
  
  var start: CGPoint?
  var end: CGPoint?
  
  var isActive: Bool = false
  var animationDuration: CFTimeInterval?
  
  fileprivate var linePath: CGMutablePath
  
  
  // MARK — Initializers
  override init() {
    self.linePath = CGMutablePath()
    super.init()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  init(start: CGPoint, _ end: CGPoint) {
    self.linePath = CGMutablePath()
    self.start = start
    self.end = end
    super.init()
  }
}



// MARK — Draw Functions
extension LaserNode {
  
  func draw() {
    self.linePath = CGMutablePath()
    
    self.linePath.move(to: self.start!)
    self.linePath.addLine(to: self.end!)
    
//    self.path = self.laserPath
    
//    CGPathMoveToPoint(self.linePath, nil, (self.start?.x)!, (self.start?.y)!)
//    CGPathAddLineToPoint(self.linePath, nil, (self.end?.x)!, (self.end?.y)!)
    
    self.lineWidth = 4.0
    self.strokeColor = UIColor("#ff0257")
    self.alpha = 0.0 // may have to change to 0.0 for animation
  }
}



// MARK — Animation Functions
extension LaserNode {
  
  func animate() {
    
    // 1
    var appear = SKAction()
    let appearDuration: CFTimeInterval = 1.0
    appear = SKAction.fadeIn(withDuration: appearDuration)
    
    // 2
    var wait = SKAction()
    let waitDuration: CFTimeInterval = 1.0
    wait = SKAction.wait(forDuration: waitDuration)

    // 3
    var disappear = SKAction()
    let disappearDuration: CFTimeInterval = 1.0
    disappear = SKAction.fadeOut(withDuration: disappearDuration)
    
    // 1 - 3
    var colorize = SKAction()
    let colorizeDuration: CFTimeInterval = 3.0
    colorize = SKAction.colorize(with: UIColor("#911969"), colorBlendFactor: 1.0, duration: colorizeDuration)
    
    // Sequencing and Grouping
    let actionSequence = SKAction.sequence([appear, wait, disappear])
    let debugAction = SKAction.run({ print("Running Actions Now!") })
    let actionGroup = SKAction.group([actionSequence, colorize, debugAction])
    
    // Running
    self.isActive = true
    self.run(actionGroup, completion: {
      print("Action Completed")
      self.isActive = false
      self.reset()
      self.removeFromParent()
    })
  }
  
}



// MARK – Setting Functions
extension LaserNode {
  
  func set(_ start: CGPoint, _ end: CGPoint) {
    self.start = start
    self.end = end
  }
 
  
  var isSet: Bool {
    guard (self.start != nil) else { return false }
    guard (self.end != nil) else { return false }
    return true
  }
  
  
  func reset() {
    self.start = nil
    self.end = nil
    self.linePath = CGMutablePath()
    self.lineWidth = 0.0
    self.alpha = 0.0
    self.removeFromParent()
  }
}

