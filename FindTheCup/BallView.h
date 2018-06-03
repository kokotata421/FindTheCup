//
//  BallView.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ball.h"

@interface BallView : UIImageView

@property (strong, nonatomic) Ball* ball;
- (id)initWithPosition:(int)position Color:(int)color;

@end
