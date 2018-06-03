//
//  GameSelectViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/25.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageButton.h"
#import "Stage.h"
#import "NADView.h"
@import GoogleMobileAds;
@protocol GameSelectViewControllerProtocol;

@interface GameSelectViewController : UIViewController<GADBannerViewDelegate, NADViewDelegate,GADInterstitialDelegate>

@property (weak, nonatomic) id<GameSelectViewControllerProtocol> delegate;
@property (strong,nonatomic) UIImageView *gameLevelSelectView;
@property (strong, nonatomic) GADBannerView *bannerView;
@property (strong, nonatomic) GADInterstitial *interstitial;


- (void)adLoad;
- (int)setChip:(int)newChip;
- (int)getChip;
- (void)removeStageViews;

@end

@protocol GameSelectViewControllerProtocol <NSObject>

- (void)moveViewControllerFromGameSelectViewToGameViewWithLevel:(int)level Stage:(int)selectedStage;
- (void)moveViewControllerFromGameSelectViewToTitleView;
- (void)playMainBGM;
- (void)stopBGM;
- (void)touchBtnSound;
- (void)touchBtnSound2;
- (void)cancelSound;

@end
