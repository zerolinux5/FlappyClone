//
//  MyScene.m
//  FlappyClone
//
//  Created by Jesus Magana on 7/11/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

@interface MyScene(){}

@property SKSpriteNode *rectangle;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //is rectangle different from nil
    if (!self.rectangle) {
        //get a single touch
        UITouch *touch = [touches anyObject];
        //get the location of the touch
        CGPoint location = [touch locationInNode:self];
        self.rectangle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        //set the newly created node position to the position of the touch
        self.rectangle.position = location;
        //initialize the physicsBody with the size of the rectangle
        self.rectangle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rectangle.size];
        //gravity is going to be simulated on this node
        self.rectangle.physicsBody.affectedByGravity = YES;
        self.rectangle.physicsBody.mass = 0.5f;
        //adding the node to the scene
        [self addChild:self.rectangle];
    }
    else{
        [self.rectangle.physicsBody applyImpulse:CGVectorMake(0.0f, 250.0f)];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
