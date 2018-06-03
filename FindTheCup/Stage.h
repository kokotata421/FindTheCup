//
//  Stage.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/27.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stage : NSObject

@property int level;
@property int numberOfStage;
@property int times;
@property float interval;
@property float speed;
@property int numberOfBall;
@property int paysOff;
@property int bet;

- (id)initWithLevel:(int)level Number:(int)number;

@end
