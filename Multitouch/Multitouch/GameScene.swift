//
//  GameScene.swift
//  Multitouch
//
//  Created by Sean Alling on 12/5/16.
//  Copyright (c) 2016 Alling Katz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var selectedNodes = [SKSpriteNode : UITouch]()
  var player1 = Player(imageNamed: "player1")
  var player2 = Player(imageNamed: "player2")
  
  var activeLasers = [SKShapeNode]()
  
  
  override func didMove(to view: SKView) {
    /* Setup your scene here */
    
    self.backgroundColor = UIColor.black
    
    player1.size = CGSize(width: 100, height: 100)
    let player1StartLocation = CGPoint(x: self.frame.midY + 150, y: self.frame.midY)
    player1.position = player1StartLocation
    player1.name = "player1"
    self.addChild(player1)
    
    player2.size = CGSize(width: 100, height: 100)
    let player2StartLocation = CGPoint(x: self.frame.midY - 150, y: self.frame.midY)
    player2.position = player2StartLocation
    player2.name = "player2"
    self.addChild(player2)
    
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    
    /* Called before each frame is rendered */
    
  }
}


// MARK: - Touch Event Handling
extension GameScene {
  
  //
  // Touches Began Function
  //
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Debug Print
    print("touchesBegan")
    
    registerSelectedNodes(touches)
    dragNodes(touches, nodeKeys: ["player1", "player2"])
    
    Firing: if shouldFire(touches) {
      
//      let laser = SKShapeNode()
//      let path = CGPathCreateMutable()
      
      let playerOneTouch = touchesForNode("player1", touches)?.first!
      let exclusiveTouches = touchesNotForNode("player1", touches)
      
      guard (exclusiveTouches?.count == 1) else { break Firing }
      
      let otherTouch = exclusiveTouches?.first!
      
      let touchLocationOne = playerOneTouch?.location(in: self)
      let touchLocationTwo = otherTouch?.location(in: self)
      
//      CGPathMoveToPoint(path, nil, (touchLocationOne?.x)!, (touchLocationOne?.y)!)
//      CGPathAddLineToPoint(path, nil, (touchLocationTwo?.x)!, (touchLocationTwo?.y)!)
//
//      laser.path = path
//      laser.lineWidth = 4.0
//      laser.fillColor = UIColor("#ff0275")
//      laser.strokeColor = UIColor("#ff0275")
//      self.addChild(laser)
//      self.activeLasers.append(laser)
//      laser.fadeOut()      
      let rotateAngle = self.rotateAngle(touchLocationOne!, toPoint: touchLocationTwo!)
      player1.rotate(rotateAngle)
      
      let laser = LaserShapeNode(touchLocationOne!, touchLocationTwo!)
      self.addChild(laser)
      self.activeLasers.append(laser)
      laser.animate()
    }
//    dragNodes(touches, nodeKeys: ["player1", "player2"])
  }
  
  //
  // Touches Moved Function
  //
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Debug Print
    print("touchesMoved")
    
    registerSelectedNodes(touches)
    
    dragNodes(touches, nodeKeys: ["player1", "player2"])
    
    Firing: if shouldFire(touches) {
      
//      let laser = SKShapeNode()
//      let path = CGPathCreateMutable()
      
      let playerOneTouch = touchesForNode("player1", touches)?.first!
      let exclusiveTouches = touchesNotForNode("player1", touches)
      
      guard (exclusiveTouches?.count == 1) else { break Firing }
      
      let otherTouch = exclusiveTouches?.first!
      
      let touchLocationOne = playerOneTouch?.location(in: self)
      let touchLocationTwo = otherTouch?.location(in: self)
      
//      CGPathMoveToPoint(path, nil, (touchLocationOne?.x)!, (touchLocationOne?.y)!)
//      CGPathAddLineToPoint(path, nil, (touchLocationTwo?.x)!, (touchLocationTwo?.y)!)
      
//      laser.path = path
//      laser.lineWidth = 4.0
//      laser.fillColor = UIColor("#ff0257")
//      laser.strokeColor = UIColor("#ff0257")
//      self.addChild(laser)
//      self.activeLasers.append(laser)
//      laser.fadeOut()
      let rotateAngle = self.rotateAngle(touchLocationOne!, toPoint: touchLocationTwo!)
      player1.rotate(rotateAngle)
      
      let laser = LaserShapeNode(touchLocationOne!, touchLocationTwo!)
      self.addChild(laser)
      self.activeLasers.append(laser)
      laser.animate()
    }
//    dragNodes(touches, nodeKeys: ["player1", "player2"])
  }
  
  //
  // Touches Ended Function
  //
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Debug Print
    print("touchesEnded")
    
    for node in activeLasers {
      node.removeFromParent()
      self.activeLasers.removeFirst()
    }
//    self.selectedNodes.removeAll()
  }
}


// MARK: - Touch & Node Identification
extension GameScene {
  
  //
  // TouchesForNode Function
  //
  
  func touchesForNode(_ imageNamed: String?, _ touches: Set<UITouch>) -> Set<UITouch>? {
    
    var inclusiveTouches = Set<UITouch>()
    for touch in touches {
      let location = touch.location(in: self)
      if let node = self.atPoint(location) as? SKSpriteNode {
        if node.name == imageNamed {
          inclusiveTouches.insert(touch)
        }
      }
    }
    if inclusiveTouches.isEmpty {
      return nil
    }
    else {
      return inclusiveTouches
    }
  }
  
  //
  // TouchesNotForNode
  //
  
  func touchesNotForNode(_ imageNamed: String?, _ touches: Set<UITouch>) -> Set<UITouch>? {
    
    var exclusiveTouches = touches
    if let excludedTouches = touchesForNode(imageNamed, touches) {
      for touch in excludedTouches {
        exclusiveTouches.remove(touch)
      }
    }
    return exclusiveTouches
  }
}


// MARK: - Nodes in Drag
extension GameScene {
  
  //
  // DragNodes Function
  //
  
  func dragNodes(_ touches: Set<UITouch>, nodeKeys: [String]) {
    
    for key in nodeKeys {
      if let firstTouch = touchesForNode(key, touches)?.first {
        let location = firstTouch.location(in: self)
        let nodeTouched = self.atPoint(location)
        nodeTouched.position = location
        print("node dragged : \(nodeTouched.name)")
      }
    }
  }
}


// MARK: - Player Selection
extension GameScene {
  
  //
  // isNodeSelected Function
  //
  
  func isNodeSelected(_ imageNamed: String?, _ touches: Set<UITouch>) -> Bool {
    
    let nodeTouches = touchesForNode(imageNamed, touches)
    guard (nodeTouches != nil) else { return false }
    
    for touch in nodeTouches! {
      let location = touch.location(in: self.view)
      // Debug Print
      print("player1 @ x = \(location.x), y = \(location.y)")
    }
    return true
  }
  
  //
  // RegisterSelectedNodes
  //
  
  func registerSelectedNodes(_ touches: Set<UITouch>) {
    
    for touch in touches {
      let location = touch.location(in: self)
      if let node = self.atPoint(location) as? SKSpriteNode {
        self.selectedNodes.updateValue(touch, forKey: node)
      }
    }
  }
}


// MARK: - Game Logic
extension GameScene {
  
  // 
  // ShouldFire Function
  //
  
  func shouldFire(_ touches: Set<UITouch>) -> Bool {
    
    // Determine if touch meets requirements to be activated as a LineVector & animated
    // The following must be met to fire:
    //
    //   (1) one touch is inside player1 node
    //   (2) there are 2 touches (i.e., UITouch.count == 2)
    
    if (isNodeSelected("player1", touches) && touches.count == 2) {
      print("shouldFire")
      return true
    } else {
      return false
    }
  }
  
  
  //
  //  Adjusted Angle Calculation
  //
  func rotateAngle(_ origin: CGPoint, toPoint: CGPoint) -> CGFloat {
    
    let adjustedPoint = CGPoint(x: (toPoint.x - origin.x), y: (toPoint.y - origin.y))
    let magnitude = sqrt(pow(adjustedPoint.x, 2) + pow(adjustedPoint.y, 2))
    let unitPoint = CGPoint(x: (adjustedPoint.x / magnitude), y: (adjustedPoint.y / magnitude))
    
    var angle: CGFloat = 0
    
    if (adjustedPoint.x > 0) {
      
      if (adjustedPoint.y > 0) {
        // Quadrant 1
        angle = atan(unitPoint.y / unitPoint.x)
      }
      else if (adjustedPoint.y < 0) {
        // Quadrant 4
        angle = atan(abs(unitPoint.x / unitPoint.y)) + CGFloat(M_PI) + CGFloat(M_PI / 2)
      }
    }
    else if (adjustedPoint.x < 0) {
    
      if (adjustedPoint.y > 0) {
        // Quadrant 2
        angle = atan(abs(unitPoint.x / unitPoint.y)) + CGFloat(M_PI / 2)
        
      }
      else if (adjustedPoint.y < 0) {
        // Quadrant 3
        angle = atan(abs(unitPoint.y / unitPoint.x)) +
        CGFloat(M_PI)
      }
    }
    return angle
  }
}
