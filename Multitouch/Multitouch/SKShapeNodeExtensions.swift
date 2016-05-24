//
//  SKShapeNodeExtensions.swift
//  Multitouch
//
//  Created by Sean Alling on 23/5/16.
//  Copyright © 2016 Alling Katz. All rights reserved.
//

import Foundation
import SpriteKit

extension SKShapeNode {
  
  func fadeOut() {
    
    let fadeDuration = 1.0
    let fadeAction = SKAction.fadeOutWithDuration(fadeDuration)
    
    let waitDuration = 0.25
    let waitAction = SKAction.waitForDuration(waitDuration)
    
    let actionSequence = SKAction.sequence([waitAction, fadeAction, SKAction.runBlock({ self.removeFromParent() })])
    
    self.runAction(actionSequence)
  }
}