//
//  Cup.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "Cup.h"

@implementation Cup

- (id)initWithPosition:(int)position Color:(color)color{
    self = [super init];
    
    if(self){
        self.position = position;
        self.color = color;
        self.ball = nil;
    }
    return self;
}

@end
