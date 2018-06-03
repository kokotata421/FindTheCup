//
//  Cup.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "CupBall.h"
#import "Ball.h"

@interface Cup : CupBall

@property (strong, nonatomic)Ball* ball;
@property (assign) color color;
@property (assign) int position;

- (id)initWithPosition:(int)position Color:(color)color;

@end
