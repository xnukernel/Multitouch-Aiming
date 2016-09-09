//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import SpriteKit



//
//    Playground Container Setup
//
//
let containerWidth: CGFloat = 375.0
let containerHeight: CGFloat = 667.0
let containerCenter: CGPoint = CGPointMake((containerWidth/2), (containerHeight/2))

let containerView = SKView(frame: CGRect(x: 0.0, y: 0.0,
                           width: containerWidth, height: containerHeight))

XCPShowView("Container View", view: containerView)

let containterScene: SKScene = SKScene(size: CGSizeMake(containerWidth, containerHeight))
containerView.presentScene(containterScene)




//
//    Player1 Simulation
//
//
let squareLeg: CGFloat = 25.0

containerCenter.x
containerCenter.y

let squareOriginX = containerCenter.x - (squareLeg/2)
let squareOriginY = containerCenter.y - (squareLeg/2)
let squareOrigin = CGPointMake(squareOriginX, squareOriginY)

//let square = UIView(frame: CGRectMake(squareOrigin.x, squareOrigin.y, 25, 25))
//square.backgroundColor = UIColor.blueColor()
//containerView.addSubview(square)

let square = SKShapeNode(rectOfSize: CGSize(width: 25, height: 25), cornerRadius: 0.0)
square.fillColor = SKColor.whiteColor()
square.position = containerCenter
containterScene.addChild(square)



//
//    Random Touch Location
//
//
func randomCGFloat(max: CGFloat) -> CGFloat {
  
  return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * max
}

let randomX1 = randomCGFloat(containerWidth)
let randomY1 = randomCGFloat(containerHeight)
let touchLocation = CGPoint(x: randomX1, y: randomY1)




//
//    Touch Circle for Touch Illumination
//
func drawCircle(center: CGPoint, radius: CGFloat) {
  
  let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
  
  let shapeLayer = CAShapeLayer()
  shapeLayer.path = circlePath.CGPath
  
  shapeLayer.fillColor = UIColor.clearColor().CGColor
  shapeLayer.strokeColor = UIColor.grayColor().CGColor
  shapeLayer.lineWidth = 1.75
  
  containerView.layer.addSublayer(shapeLayer)
}

drawCircle(touchLocation, radius: (squareLeg / 2))




//
//    Laser Node for Vector Illumination
//
let laser = SKShapeNode()
let path = CGPathCreateMutable()

//CGPathMoveToPoint(path, nil, containerCenter.x, containerCenter.y)
//CGPathAddLineToPoint(path, nil, touchLocation.x, touchLocation.y)
//CGPathMoveToPoint(path, nil, touchLocation.x, touchLocation.y)
//CGPathAddLineToPoint(path, nil, containterScene.anchorPoint.x, containerCenter.y)

containerCenter
touchLocation

laser.path = path
laser.lineWidth = 1.25

laser.fillColor = UIColor.greenColor()
laser.strokeColor = UIColor.greenColor()


//
//    Adjusted Origin from Center
//
//
let touchAdjustedLocation = CGPointMake((touchLocation.x - containerCenter.x), -(touchLocation.y - containerCenter.y))



//
//    Quadrant (sign tests)
//
//
let presetRotation: CGFloat = (CGFloat(M_PI)/2)
var angle: CGFloat = 0
var rotation: CGFloat = 0


touchAdjustedLocation
let magnitude = sqrt(pow(touchAdjustedLocation.x, 2) + pow(touchAdjustedLocation.y, 2))

let unitTouchAdjusted = CGPointMake((touchAdjustedLocation.x / magnitude), (touchAdjustedLocation.y / magnitude))

if (touchAdjustedLocation.x > 0 && touchAdjustedLocation.y > 0) {
  // Quadrant 1
//  quadrant = Quadrant.one
//  angle = tan(abs(touchAdjustedLocation.y / touchAdjustedLocation.x))
  angle = atan(unitTouchAdjusted.y / unitTouchAdjusted.x)
}
else if (touchAdjustedLocation.x > 0 && touchAdjustedLocation.y < 0) {
  // Quadrant 4
//  quadrant = Quadrant.four
  angle = atan(abs(unitTouchAdjusted.x / unitTouchAdjusted.y)) + CGFloat(M_PI) + CGFloat(M_PI / 2)
}
else if (touchAdjustedLocation.x < 0 && touchAdjustedLocation.y > 0) {
  // Quadrant 2
//  quadrant = Quadrant.two
  angle = tan(abs(unitTouchAdjusted.x / unitTouchAdjusted.y)) + CGFloat(M_PI / 2)
}
else if (touchAdjustedLocation.x < 0 && touchAdjustedLocation.y < 0) {
  // Quadrant 3
//  quadrant = Quadrant.three
  angle = atan(abs(unitTouchAdjusted.y / unitTouchAdjusted.x)) + CGFloat(M_PI)
} else {
  // nil
}

// Quandrant X & Y fixes with tangent()

rotation = angle + presetRotation
var angleDeg = angle * (180 / CGFloat(M_PI))
var rotationDeg = rotation * (180 / CGFloat(M_PI))



//
//   Rotate Sprite
//
//
let rotateAction = SKAction.rotateByAngle(rotation, duration: 1.0)
square.runAction(rotateAction)



