//
//  StageButton.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/27.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "StageButton.h"

@implementation StageButton

typedef struct{ float x; float y; float width; float height;} scale;


static int bet[3][24] = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3},{1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7},{1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10}};
static int paysOff[3][24] = {{2, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 7, 7, 8, 8, 9, 9, 10, 10, 12, 12, 13, 13}, {2, 2, 3, 3, 5, 5, 6, 7, 10, 10, 11, 11, 12, 12, 15, 15, 18, 18, 20, 22, 24, 25, 26, 27}, {2, 2, 4, 5, 7, 7, 9, 10, 10, 12, 13, 15, 18, 19, 20, 22, 26, 26, 28, 28, 30, 32, 35, 40}};
static NSString* stageImage = @"Stage";
static NSString* lockStageImage = @"LockStage";
static NSString* bonusChipImage = @"BonusChip";
static NSString* clearChipImage = @"ClearChip";
static NSString* stageLockImage = @"StageLock";
static NSString* number0 = @"StageNumber_0";
static NSString* number1 = @"StageNumber_1";
static NSString* number2 = @"StageNumber_2";
static NSString* number3 = @"StageNumber_3";
static NSString* number4 = @"StageNumber_4";
static NSString* number5 = @"StageNumber_5";
static NSString* number6 = @"StageNumber_6";
static NSString* number7 = @"StageNumber_7";
static NSString* number8 = @"StageNumber_8";
static NSString* number9 = @"StageNumber_9";
static NSString* bonusNumber0 = @"BonusNumber_0";
static NSString* bonusNumber1 = @"BonusNumber_1";
static NSString* bonusNumber2 = @"BonusNumber_2";
static NSString* bonusNumber3 = @"BonusNumber_3";
static NSString* bonusNumber4 = @"BonusNumber_4";
static NSString* bonusNumber5 = @"BonusNumber_5";
static NSString* bonusNumber6 = @"BonusNumber_6";
static NSString* bonusNumber7 = @"BonusNumber_7";
static NSString* bonusNumber8 = @"BonusNumber_8";
static NSString* bonusNumber9 = @"BonusNumber_9";

static scale stageLockScale = {0, 0.301, 0.46, 0.54};
static float clearChipSizeScale = 0.25;
static float stageNumberWidthScale = 0.197;
static float stageNumberHeightScale = 0.3263;
static float stageNumberYscale = 0.34;
static float stageNumberXScale[2] = {0.4965, 0.2913};
static float betNumberWidthScale = 0.0921;
static float betNumberHeightScale = 0.15;
static float betNumberYScale = 0.7736;
static float betNumberXScale = 0.2235;
static float betNumberXScale2[2] = {0.2748, 0.172};
static float paysOffNumberXScale = 0.6906;
static float paysOffNumberXScale2[2] = {0.7419, 0.6392};

- (id)initWithLevel:(int)level Stage:(int)stage Clear:(BOOL)clear{
    self = [super init];
    
    if(self){
        self.level = level;
        self.stage = stage;
        self.clear = clear;
        self.paysOff = paysOff[level][stage];
        self.bet = bet[level][stage];
        self.clipsToBounds = NO;
    }
    
    self.stageNumberViews = [NSArray arrayWithObjects:number0, number1, number2, number3, number4, number5, number6, number7, number8, number9, nil];
    self.bonusNumberViews = [NSArray arrayWithObjects:bonusNumber0, bonusNumber1, bonusNumber2, bonusNumber3, bonusNumber4, bonusNumber5, bonusNumber6, bonusNumber7, bonusNumber8, bonusNumber9, nil];
    return self;
}

- (void)addClearChipView{
    CGSize clearChipSize = CGSizeMake(self.frame.size.width * clearChipSizeScale, self.frame.size.width * clearChipSizeScale);
    UIImageView *clearChipView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - clearChipSize.width / 2.0, 0 - clearChipSize.height / 2.0, clearChipSize.width, clearChipSize.height)];
    clearChipView.image = [UIImage imageNamed:clearChipImage];
    [self addSubview:clearChipView];
}

- (void)addPaysOffNumberView{
    CGSize paysOffNumberSize = CGSizeMake(self.frame.size.width * betNumberWidthScale, self.frame.size.height * betNumberHeightScale);
    if(paysOff[self.level][self.stage] < 10){
        CGRect paysOffNumberFrame = CGRectMake(self.frame.size.width * paysOffNumberXScale, self.frame.size.height * betNumberYScale, paysOffNumberSize.width, paysOffNumberSize.height);
        
        UIImageView *paysOffNumberView = [[UIImageView alloc] initWithFrame:paysOffNumberFrame];
        paysOffNumberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BetPaysOffNumber_%d", paysOff[self.level][self.stage]]];
        [self addSubview:paysOffNumberView];
    } else{
        int number = paysOff[self.level][self.stage];
        for(int i = 0; i < 2 ; i++){
            CGRect paysOffNumberFrame = CGRectMake(self.frame.size.width * paysOffNumberXScale2[i], self.frame.size.height * betNumberYScale, paysOffNumberSize.width, paysOffNumberSize.height);
            
            UIImageView *paysOffNumberView = [[UIImageView alloc] initWithFrame:paysOffNumberFrame];
            paysOffNumberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BetPaysOffNumber_%d", number % 10]];
            number /= 10;
            [self addSubview:paysOffNumberView];
        }
    }
}

- (void)addBetNumberView{
    CGSize betNumberSize = CGSizeMake(self.frame.size.width * betNumberWidthScale, self.frame.size.height * betNumberHeightScale);
    
    if(bet[self.level][self.stage] < 10){
        CGRect betNumberFrame = CGRectMake(self.frame.size.width * betNumberXScale, self.frame.size.height * betNumberYScale, betNumberSize.width, betNumberSize.height);
        
        UIImageView *betNumberView = [[UIImageView alloc] initWithFrame:betNumberFrame];
        betNumberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BetPaysOffNumber_%d", bet[self.level][self.stage]]];
        [self addSubview:betNumberView];
    } else{
        int number = bet[self.level][self.stage];
        for(int i = 0; i < 2 ; i++){
            CGRect betNumberFrame = CGRectMake(self.frame.size.width * betNumberXScale2[i], self.frame.size.height * betNumberYScale, betNumberSize.width, betNumberSize.height);
            
            UIImageView *betNumberView = [[UIImageView alloc] initWithFrame:betNumberFrame];
            betNumberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BetPaysOffNumber_%d", number % 10]];
            number /= 10;
            [self addSubview:betNumberView];
        }
    }
}

- (void)addNumberView{
    [self setImage:[UIImage imageNamed:stageImage] forState:UIControlStateNormal];
    if(self.stage <  9){
        CGSize stageNumberSize = CGSizeMake(self.frame.size.width * stageNumberWidthScale, self.frame.size.height * stageNumberHeightScale);
        CGRect stageNumberFrame = CGRectMake(self.frame.size.width / 2.0 - stageNumberSize.width / 2.0, self.frame.size.height * stageNumberYscale, stageNumberSize.width, stageNumberSize.height);
        
        UIImageView *stageNumberView = [[UIImageView alloc] initWithFrame:stageNumberFrame];
        stageNumberView.image = [UIImage imageNamed:self.stageNumberViews[self.stage + 1]];
        [self addSubview:stageNumberView];
    } else{
        int number = self.stage + 1;
        for(int i = 0; i < 2 ; i++){
            CGSize stageNumberSize = CGSizeMake(self.frame.size.width * stageNumberWidthScale, self.frame.size.height * stageNumberHeightScale);
            CGRect stageNumberFrame = CGRectMake(self.frame.size.width * stageNumberXScale[i], self.frame.size.height * stageNumberYscale, stageNumberSize.width, stageNumberSize.height);
            
            UIImageView *stageNumberView = [[UIImageView alloc] initWithFrame:stageNumberFrame];
            stageNumberView.image = [UIImage imageNamed:self.stageNumberViews[number % 10]];
            number /= 10;
            [self addSubview:stageNumberView];
        }
    }
}

- (void)addLockView{
    [self setImage:[UIImage imageNamed:lockStageImage] forState:UIControlStateNormal];
    CGSize stageLockSize = CGSizeMake(self.frame.size.width * stageLockScale.width, self.frame.size.height * stageLockScale.height);
    CGRect stageLockFrame = CGRectMake(self.frame.size.width / 2.0 - stageLockSize.width / 2.0, self.frame.size.height * stageLockScale.y, stageLockSize.width, stageLockSize.height);
    UIImageView* stageLockView = [[UIImageView alloc] initWithFrame:stageLockFrame];
    stageLockView.image = [UIImage imageNamed:stageLockImage];
    stageLockView.alpha = 0.8;
    [self addSubview:stageLockView];
}

- (void)removeViews{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
