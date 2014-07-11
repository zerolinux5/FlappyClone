//
//  MyScene.m
//  FlappyClone
//
//  Created by Jesus Magana on 7/11/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

@interface MyScene() <SKPhysicsContactDelegate>{}

@property SKSpriteNode *rectangle;

@property SKAction *obstacleLoop;
@property BOOL gameOver;
@property UIAlertView *gameOverAlert;
@property SKLabelNode *startGameLabel;

typedef enum : uint8_t {
    ColliderTypeRectangle = 1,
    ColliderTypeObstacle  = 2
} ColliderType;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        
        self.physicsWorld.contactDelegate = self;
        
        SKAction *callAddObstacles = [SKAction performSelector:@selector(addObstacles) onTarget:self];
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *waitThenAdd = [SKAction sequence:@[callAddObstacles,wait]];
        self.obstacleLoop = [SKAction repeatActionForever:waitThenAdd];
        
        self.gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        self.startGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.startGameLabel.text = @"Tap to play";
        self.startGameLabel.fontSize = 15;
        self.startGameLabel.position = CGPointMake(size.width/2, size.height/2);
        
        self.gameOver = NO;
        
        self.rectangle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        [self setRectanglePositionAndAddToScene];
        [self addChild:self.startGameLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (!self.rectangle.physicsBody||self.gameOver) {
        if (!self.rectangle.physicsBody) {
            [self.startGameLabel removeFromParent];
            //initialize the physicsBody with the size of the rectangle
            self.rectangle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rectangle.size];
            //gravity is going to be simulated on this node
            self.rectangle.physicsBody.affectedByGravity = YES;
            self.rectangle.physicsBody.allowsRotation = NO;
            self.rectangle.physicsBody.mass = 0.5f;
            //collision detection
            self.rectangle.physicsBody.categoryBitMask = ColliderTypeRectangle;
            self.rectangle.physicsBody.collisionBitMask = ColliderTypeObstacle | ColliderTypeRectangle;
            self.rectangle.physicsBody.contactTestBitMask = ColliderTypeObstacle;
        }
        if (self.gameOver) {
            [self removeAllChildren];
            self.paused = NO;
            self.gameOver = NO;
            [self setRectanglePositionAndAddToScene];
        }
        [self.rectangle runAction:self.obstacleLoop withKey:@"obstacles"];
    }
    else{
        [self.rectangle.physicsBody applyImpulse:CGVectorMake(0.0f, 250.0f)];
    }
    
}

-(void)addObstacles{
    float obstacleWidth = 50.0f;
    
    SKSpriteNode *upperObstacle = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(obstacleWidth, self.size.height/2-100)];
    
    SKSpriteNode *lowerObstacle = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(obstacleWidth, self.size.height/2-100)];
    
    upperObstacle.position = CGPointMake(self.size.width+obstacleWidth/2, self.size.height-upperObstacle.size.height/2);
    
    lowerObstacle.position = CGPointMake(self.size.width+obstacleWidth/2, lowerObstacle.size.height/2);
    
    SKAction *moveObstacle = [SKAction moveToX:-obstacleWidth/2 duration:2.0];
    
    [upperObstacle runAction:moveObstacle completion:^(void){
        [upperObstacle removeFromParent];
    }];
    [lowerObstacle runAction:moveObstacle completion:^(void){
        [lowerObstacle removeFromParent];
    }];
    
    //collision detection
    upperObstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:upperObstacle.size];
    //we don't want this object to be animated by the physics engine
    upperObstacle.physicsBody.dynamic = NO;
    upperObstacle.physicsBody.categoryBitMask = ColliderTypeObstacle;
    //same with the lower obstacle
    lowerObstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lowerObstacle.size];
    lowerObstacle.physicsBody.dynamic = NO;
    lowerObstacle.physicsBody.categoryBitMask = ColliderTypeObstacle;
    [self addChild:upperObstacle];
    [self addChild:lowerObstacle];
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if ((contact.bodyA.categoryBitMask == ColliderTypeRectangle && contact.bodyB.categoryBitMask == ColliderTypeObstacle) || (contact.bodyB.categoryBitMask == ColliderTypeRectangle && contact.bodyA.categoryBitMask == ColliderTypeObstacle)) {
        self.paused = YES;
        [self.rectangle removeActionForKey:@"obstacles"];
        self.gameOver = YES;
        [self.gameOverAlert show];
        [self addChild:self.startGameLabel];
    }
    
}

-(void)setRectanglePositionAndAddToScene{
    self.rectangle.position = CGPointMake(60, self.size.height/2);
    [self addChild:self.rectangle];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
