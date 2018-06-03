//
//  GameViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/30.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stage.h"
#import "CupView.h"
#import "BallView.h"
@protocol GameViewControllerProtocol;

@interface GameViewController : UIViewController<CupViewDelegate,CAAnimationDelegate>

@property (weak, nonatomic) id<GameViewControllerProtocol> delegate;
@property (strong, nonatomic) UIImageView* gameView;
@property (strong, nonatomic) Stage *stage;
@property (strong, nonatomic) BallView *redBall;
@property (strong, nonatomic) BallView *greenBall;
@property (strong, nonatomic) BallView *blueBall;
@property (strong, nonatomic) BallView *orangeBall;
@property (strong, nonatomic) BallView *yellowBall;
@property (strong, nonatomic) CupView *redCup;
@property (strong, nonatomic) CupView *greenCup;
@property (strong, nonatomic) CupView *blueCup;
@property (strong, nonatomic) CupView *orangeCup;
@property (strong, nonatomic) CupView *yellowCup;
@property (strong, nonatomic) UIButton *tapToStartBtn;







- (void)playGame;
- (BOOL)getResult;

@end

@protocol GameViewControllerProtocol <NSObject>

- (void)moveViewControllerFromGameViewToGameOverViewWithLevel:(int)level Stage:(int)stage Result:(BOOL)result;
- (void)playMainBGM;
- (void)stopBGM;
- (void)shuffleSound;
- (void)countDownSound;
- (void)timeUpSound;
- (void)selectCupSound;

@end
