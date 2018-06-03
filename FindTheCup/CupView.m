//
//  CupView.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "CupView.h"

@implementation CupView

static NSString* redCupImage = @"RedCup";
static NSString* blueCupImage = @"BlueCup";
static NSString* greenCupImage = @"GreenCup";
static NSString* orangeCupImage = @"OrangeCup";
static NSString* yellowCupImage = @"YellowCup";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithPosition:(int)position Color:(color)color Delegate:(id)delegate{
    self = [super init] ;
    if(self){
        self.cup = [[Cup alloc] initWithPosition:position Color:color];
        self.userInteractionEnabled = NO;
        self.delegate = delegate;
        switch (color) {
            case RED:self.image = [UIImage imageNamed:redCupImage];
                break;
            case BLUE:self.image = [UIImage imageNamed:blueCupImage];
                break;
            case GREEN:self.image = [UIImage imageNamed:greenCupImage];
                break;
            case ORANGE:self.image = [UIImage imageNamed:orangeCupImage];
                break;
            case YELLOW:self.image = [UIImage imageNamed:yellowCupImage];
                break;
            default: break;
        }
    }
    return self;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SEL sel = @selector(selectCup:);
    id delegate = self.delegate;
    
    
    if(delegate && [delegate respondsToSelector:sel])
        [delegate selectCup:self.cup];
    
}

- (void)dealloc{
    self.delegate = nil;
}

@end


