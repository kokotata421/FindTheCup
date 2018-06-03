//
//  Ball.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "CupBall.h"

@interface Ball : CupBall

@property (assign) color color;
@property (assign) int position;

- (id)initWithPosition:(int)position Color:(color)color;

@end
