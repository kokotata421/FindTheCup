//
//  CupView.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cup.h"


@protocol CupViewDelegate;


@interface CupView : UIImageView

@property (strong, nonatomic) Cup* cup;
@property (strong) id<CupViewDelegate> delegate;

-(id)initWithPosition:(int)position Color:(color)color Delegate:(id)delegate;

@end

@protocol CupViewDelegate <NSObject>

- (void)selectCup:(Cup *)cup;

@end