//
//  GameOverViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/06/12.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"
#import "Stage.h"
@import GoogleMobileAds;
@protocol GameOverViewControllerProtocol;

@interface GameOverViewController : UIViewController<GADBannerViewDelegate, NADViewDelegate,GADInterstitialDelegate>

@property (weak, nonatomic) id<GameOverViewControllerProtocol> delegate;
@property (strong, nonatomic) Stage * stage;
@property (assign) BOOL result;
@property (strong) UIImageView *gameOverView;
@property (strong) UIImageView *chipView;
@property (strong) UIImageView *resultView;
@property (strong) UIButton *retryBtn;
@property (strong) UIButton *stageBtn;
@property (strong) UIButton *titleBtn;
@property (strong, nonatomic) GADBannerView *bannerView;
@property (strong, nonatomic) GADInterstitial * interstitial;

- (void)gameOverViewSetUp;
- (void)setResult:(BOOL)Result;
- (int)getChip;
- (void)removeViews;

@end


@protocol GameOverViewControllerProtocol <NSObject>

- (void)moveViewControllerFromGameOverViewToTitleView;
- (void)moveViewControllerFromGameOverViewToGameSelectView;
- (void)moveViewControllerFromGameOverViewToGameViewWithLevel:(int)level Stage:(int)stage;
- (void)touchBtnSound;
- (void)touchBtnSound2;
- (void)chipUpSound;
- (void)chipDownSound;
- (void)lostSound;
- (void)wonSound;
- (void)cancelSound;
@end
