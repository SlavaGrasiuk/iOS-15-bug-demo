/*
==========================================================================

 IOS 15 BUG DEMO
 
 !!!!!!!!!!!!!!!!!LOOK AT THE CODE BELOW!!!!!!!!!!!!!!!!!
 
==========================================================================
*/

#import "GameScene.h"
#import <UIKit/UIAlertController.h>

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    SKShapeNode *_restrictedArea;
    BOOL _ignoreTouch;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    _ignoreTouch = FALSE;
    _restrictedArea = (SKShapeNode*)[self childNodeWithName:@"//restrictedArea"];
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
}


- (void)touchDownAtPoint:(CGPoint)pos {
    if ([_restrictedArea containsPoint:pos]) {
        _ignoreTouch = TRUE;
        BOOL __block buttonClicked = FALSE;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Don't touch this!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay:("
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                                buttonClicked = TRUE;
                                                                self->_ignoreTouch = FALSE;
                                                           }];
        [alert addAction:action];
        alert.preferredAction = action;
        
        [_viewController presentViewController:alert animated:YES completion:nil];
        
        /*
            !!! HERE IS AN BUG !!!
         
            !!! IN IOS VERSION < 15 IT WORKS WELL - A MESSAGE SHOWS ON THE SCREEN AND IT RESPONDS TO TOUCHES
         
            !!! BUT ON IOS VERSION >= 15 THIS CODE HANGS AND THE MESSAGE DOESN'T EVEN APPEAR ON THE SCREEN !!!
         */
        
        while (!buttonClicked)      // WORKS WELL ON IOS VERSION < 15
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; // NO PROBLEM WTIH THIS ON IOS VERSION < 15
        }
        
        return;     // IN IOS VERSION > 15 WE WILL NEVER GO HERE
    }
    
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    if (!_ignoreTouch) {
        SKShapeNode *n = [_spinnyNode copy];
        n.position = pos;
        n.strokeColor = [SKColor blueColor];
        [self addChild:n];
    }
}

- (void)touchUpAtPoint:(CGPoint)pos {
    if (!_ignoreTouch) {
        SKShapeNode *n = [_spinnyNode copy];
        n.position = pos;
        n.strokeColor = [SKColor redColor];
        [self addChild:n];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
