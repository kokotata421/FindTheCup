//
//  Stage.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/27.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "Stage.h"

@implementation Stage

static int const timesOfStage[3][24] = {{5, 5, 7, 7, 5, 5, 7, 10, 10, 10, 10, 10, 10, 12, 12, 12, 10, 10, 12, 15, 12, 12, 15, 15}, {7, 10, 7, 10, 10, 10, 12, 12, 7, 10, 12, 10, 12, 15, 12, 15, 7, 10, 10, 12, 15, 15, 16, 18}, {12,7,10,13,15,10,10,12,15,13,15,15,10,12,15,15,13,15,15,16,17,17,20,20}};
static float const intervalsOfStage[3] = {0.1, 0.06, 0.05};
static float const speedOfStage[3][24] = {{0.6, 0.55, 0.55, 0.5, 0.6, 0.55, 0.5, 0.5, 0.3, 0.45, 0.4, 0.35, 0.3, 0.3, 0.25, 0.2, 0.5, 0.45, 0.4, 0.4, 0.35, 0.3, 0.25, 0.23},{0.3, 0.25, 0.4, 0.35, 0.2, 0.3, 0.3, 0.25, 0.35, 0.33, 0.3, 0.22, 0.3, 0.3, 0.25, 0.225, 0.45, 0.4, 0.375, 0.35, 0.325, 0.3, 0.275, 0.25},{0.2, 0.4, 0.35, 0.3, 0.275, 0.4, 0.375, 0.35, 0.35, 0.325, 0.3, 0.275, 0.4, 0.35, 0.3, 0.275, 0.4, 0.4, 0.38, 0.36, 0.34, 0.32, 0.3, 0.275}};
static int const ballsOfStage[3][24] = {{1, 1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3},{1, 1, 2, 2, 1, 2, 2, 2, 3, 3, 3, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4},{1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5}};
static int payOff[3][24] = {{2, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 7, 7, 8, 8, 9, 9, 10, 10, 12, 12, 13, 13}, {2, 2, 3, 3, 5, 5, 6, 7, 10, 10, 11, 11, 12, 12, 15, 15, 18, 18, 20, 22, 24, 25, 26, 27}, {2, 2, 4, 5, 7, 7, 9, 10, 10, 12, 13, 15, 18, 19, 20, 22, 26, 26, 28, 28, 30, 32, 35, 40}};
static int bet[3][24] = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3},{1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7},{1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10}};

@synthesize times = times;
@synthesize speed = speed;
@synthesize interval = interval;
@synthesize numberOfBall = numberOfBall;

- (id)initWithLevel:(int)level Number:(int)number{
    self = [super init];
    self.level = level;
    self.numberOfStage = number;
    self.paysOff = payOff[level][number];
    self.times = timesOfStage[level][number];
    self.interval = intervalsOfStage[level];
    self.speed = speedOfStage[level][number];
    self.numberOfBall = ballsOfStage[level][number];
    self.bet = bet[level][number];
    return self;
}

@end
