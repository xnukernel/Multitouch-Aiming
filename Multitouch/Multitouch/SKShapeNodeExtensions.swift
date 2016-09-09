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
    let fadeAction = SKAction.fadeOut(withDuration: fadeDuration)
    
    let waitDuration = 0.25
    let waitAction = SKAction.wait(forDuration: waitDuration)
    
    let actionSequence = SKAction.sequence([waitAction, fadeAction, SKAction.run({ self.removeFromParent() })])
    
    self.run(actionSequence)
  }
}
