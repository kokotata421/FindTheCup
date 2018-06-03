//
//  StageButton.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/27.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StageButtonDelegate;


@interface StageButton : UIButton

@property (strong) id<StageButtonDelegate>delegate;
@property int level;
@property int stage;
@property BOOL clear;
@property int paysOff;
@property int bet;
@property NSArray *stageNumberViews;
@property NSArray *bonusNumberViews;

- (id)initWithLevel:(int)level Stage:(int)stage Clear:(BOOL)clear;
- (void)addNumberView;
- (void)addPaysOffNumberView;
- (void)addBetNumberView;
- (void)addClearChipView;
- (void)addLockView;
- (void)removeViews;
@end


