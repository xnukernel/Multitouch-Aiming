# Multitouch
Multitouch Experiments in iOS

Multitouch Experiments
===================


The goal of this experiment is to build a framework with which to handle multi-touches for two finger firing.

----------

Touches
-------------

All touches are handled within a used GameScene: *SKScene* through the following overridden functions:

```
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){ }

override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){ }

override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) { }
```


Touches are provided as a unordered collection via a **Set** < UITouch >. Because they are unordered they must be identified via location what nodes they belong to on screen.

This is performed by the **touchesForNode( ) -> [UITouch]** and **touchesNotForNode( ) -> [UITouch]** functions.

```
func touchesForNode(imageNamed: String?, _ touches: Set<UITouch>) -> Set<UITouch>? {
    
    var inclusiveTouches = Set<UITouch>()
    for touch in touches {
      let location = touch.locationInNode(self)
      if let node = self.nodeAtPoint(location) as? SKSpriteNode {
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
```

```
func touchesNotForNode(imageNamed: String?, _ touches: Set<UITouch>) -> Set<UITouch>? {
    
    var exclusiveTouches = touches
    if let excludedTouches = touchesForNode(imageNamed, touches) {
      for touch in excludedTouches {
        exclusiveTouches.remove(touch)
      }
    }
    return exclusiveTouches
  }
```

Determining whether a node is selected (i.e., returning a Bool) is performed by the **isNodeSelected( ) -> Bool** function. 

```
func isNodeSelected(imageNamed: String?, _ touches: Set<UITouch>) -> Bool {
    
    let nodeTouches = touchesForNode(imageNamed, touches)
    guard (nodeTouches != nil) else { return false }
    
    for touch in nodeTouches! {
      let location = touch.locationInView(self.view)
      // Debug Print
      print("player1 @ x = \(location.x), y = \(location.y)")
    }
    return true
  }
```

In Multitouch, selected nodes are registered in an array in the **GameScene** for informational purposes. Note: this isn't used to calculate nor draw lines between two touches.

Dragging
-------------

Drawing nodes is performed by the **dragNodes( )** function which essentially just sets the new position of the nodes to the location of the touch within the node.

The following version does *NOT* perform node jumping bound to a new touch, touches must be dragged from their current locations.

```
func dragNodes(touches: Set<UITouch>, nodeKeys: [String]) {
    
    for key in nodeKeys {
      if let firstTouch = touchesForNode(key, touches)?.first {
        let location = firstTouch.locationInNode(self)
        let nodeTouched = self.nodeAtPoint(location)
        nodeTouched.position = location
        print("node dragged : \(nodeTouched.name)")
      }
    }
  }
```

Fire (Line Draw) Determination
-------------
Before calculating the line parameters (touch locations) we should determine whether the *touch scheme* warrants firing/line drawing. We can define/change this determination by changing the innards of the **shouldFire( ) -> Bool** function.
```
func shouldFire(touches: Set<UITouch>) -> Bool {
    
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
```


Line Calculation & Drawing
-------------
Using the functions outlined above, the line between touches is calculated using a **CGMutablePath** (note: this is a Core Graphics type alias and doesn't have methods, and is performed on via external global functions). 

We define the following if *block* as **Firing** so that we can escape the block should certain things happen within it.
Within both **touchesBegan( )** and **touchesMoved( )** the **Firing** block is defined with the ```Firing: if shouldFire(touches) {...} ```. 
Within that block, creates a **SKShapeNode** and a **CGMutablePath**. The two touches are then separated by calling the **touchesForNode( )** and **touchesNotForNode( )** functions on ``"player1"``.
The code following this separation is *guarded* from any possibility that the exclusiveTouches (i.e., not player1 touches) included more than one touch since a line can only be made of two points, one being the player1 location touch.
The **path** is then calculated from the locations of the separated touches and assigned as the **line**'s *CGPath* property. 

```laser.path = path```

Then the **line**'s properties are then defined (such as: lineWidth, strokeColor, etc.) and the line is added to the **GameScene** as a child.

```
Firing: if shouldFire(touches) {
      
      let laser = SKShapeNode()
      let path = CGPathCreateMutable()
      
      let playerOneTouch = touchesForNode("player1", touches)?.first!
      let exclusiveTouches = touchesNotForNode("player1", touches)
      
      guard (exclusiveTouches?.count == 1) else { break Firing }
      
      let otherTouch = exclusiveTouches?.first!
      
      let touchLocationOne = playerOneTouch?.locationInNode(self)
      let touchLocationTwo = otherTouch?.locationInNode(self)
      
      CGPathMoveToPoint(path, nil, (touchLocationOne?.x)!, (touchLocationOne?.y)!)
      CGPathAddLineToPoint(path, nil, (touchLocationTwo?.x)!, (touchLocationTwo?.y)!)

      laser.path = path
      laser.lineWidth = 4.0
      laser.fillColor = UIColor("#ff0257")
      laser.strokeColor = UIColor("#ff0275")
      self.addChild(laser)
      self.activeLasers.append(laser)
      
    }
```

Line Cleanup
-------------
Within **GameScene** an array of active/drawn lines is defined.  
```
var activeLasers = [SKShapeNode]()
```
This is emptied when **touchesEnded( )** is called to prevent crashing and freezing; when emptied each **SKShapeNode** is removed from its parent (the **GameScene** node) via the **.removeFromParent( )** function.
