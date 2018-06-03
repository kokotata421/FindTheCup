//
//  RankViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NADView.h"
@import GoogleMobileAds;
@protocol RankViewControllerProtocol;

@interface RankViewController : UIViewController<GADBannerViewDelegate, NADViewDelegate>

@property (weak, nonatomic) id<RankViewControllerProtocol> delegate;
@property (strong, nonatomic) UIImageView* rankView;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UISegmentedControl* segmentedCtr;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) GADBannerView *bannerView;


@end

@protocol RankViewControllerProtocol <NSObject>

- (void)moveViewControllerFromRankViewToTitleView;
- (void)touchBtnSound2;

@end
