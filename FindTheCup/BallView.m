//
//  BallView.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "BallView.h"

@implementation BallView

static NSString* redBallImage = @"RedBall";
static NSString* blueBallImage = @"BlueBall";
static NSString* greenBallImage = @"GreenBall";
static NSString* orangeBallImage = @"OrangeBall";
static NSString* yellowBallImage = @"YellowBall";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithPosition:(int)position Color:(int)color{
    self = [super init] ;
    if(self){
        self.ball = [[Ball alloc] initWithPosition:position Color:color];
    }
    switch (color) {
        case RED:self.image = [UIImage imageNamed:redBallImage];
            break;
        case BLUE:self.image = [UIImage imageNamed:blueBallImage];
            break;
        case GREEN:self.image = [UIImage imageNamed:greenBallImage];
            break;
        case ORANGE:self.image = [UIImage imageNamed:orangeBallImage];
            break;
        case YELLOW:self.image = [UIImage imageNamed:yellowBallImage];
            break;
        default: break;
    }
    return self;
}

@end
