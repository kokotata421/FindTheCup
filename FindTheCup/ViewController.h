//
//  ViewController.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/22.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TitleViewController.h"
#import "GameSelectViewController.h"
#import "GameViewController.h"
#import "GameOverViewController.h"
#import "RankViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct{ float x; float y; float width; float height;} scale;
typedef struct{ float width; float height;} sizeScale;
typedef struct{ float x; float y;} pointScale;


@interface ViewController : UIViewController<AVAudioPlayerDelegate, TitleViewContollerProtocol, GameSelectViewControllerProtocol, GameViewControllerProtocol, GameOverViewControllerProtocol, RankViewControllerProtocol>{
    
}


@property(strong, nonatomic) TitleViewController *titleViewController;
@property(strong, nonatomic) GameSelectViewController *gameSelectViewController;
@property(strong, nonatomic) GameViewController *gameViewController;
@property(strong, nonatomic) RankViewController *rankViewController;
@property(strong, nonatomic) GameOverViewController *gameOverViewController;
@property(nonatomic) AVAudioPlayer *audioPlayer;
@property (readwrite) CFURLRef soundURL;
@property (readonly) SystemSoundID soundID;

- (void)setSoundOn:(BOOL)on;
- (BOOL)getSoundOn;

@end

