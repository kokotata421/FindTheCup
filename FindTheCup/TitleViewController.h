//
//  TitleViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/09/22.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "NADView.h"
#import <UnityAds/UnityAds.h>
@import GoogleMobileAds;
@protocol TitleViewContollerProtocol;


@interface TitleViewController : UIViewController<UITextFieldDelegate, GADBannerViewDelegate, NADViewDelegate, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate>{
    
}

@property(strong, nonatomic) NSString *playerName;
@property(strong, nonatomic) UIImageView *titleView;
@property(strong, nonatomic) UIButton *playBtn;
@property(strong, nonatomic) UIButton *howToPlayBtn;
@property(strong, nonatomic) UIButton *rankBtn;
@property(strong, nonatomic) UIImageView* yourChipView;
@property(strong, nonatomic) UIImageView* rankView;
@property(strong, nonatomic) UIButton* soundBtn;
@property(strong, nonatomic) UIButton* chipAdBtn;
@property(weak, nonatomic) id<TitleViewContollerProtocol> delegate;
@property (strong, nonatomic) GADBannerView *bannerView;


- (BOOL)hasPlayerName;
- (void)setNeedOfSetup:(BOOL)Yes;
- (void)setChip:(int)newChip;
- (int)getChip;
- (void)timerOff;
- (void)removeChipNumberView;
- (void)addChipNumberView;

@end

@protocol TitleViewContollerProtocol <NSObject>

- (void)moveViewControllerFromTitleViewToGameSelectView;
- (void)moveViewControllerFromTitleViewToRankView;
- (void)playTitleBGM;
- (void)stopBGM;
- (void)touchBtnSound;
- (void)touchBtnSound2;

@end
