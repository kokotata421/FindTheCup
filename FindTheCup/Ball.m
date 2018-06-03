//
//  Ball.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "Ball.h"

@implementation Ball

- (id)initWithPosition:(int)position Color:(color)color{
    self = [super init];
    
    if(self){
        self.position = position;
        self.color = color;
    }
    return self;
}

@end
