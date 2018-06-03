//
//  ViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/22.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "ViewController.h"
#import "ALSdk.h"
#import <VungleSDK/VungleSDK.h>


@interface ViewController (){
    
}


@end

static BOOL soundOn = YES;

@implementation ViewController

@synthesize titleViewController = titleViewController;
@synthesize gameSelectViewController = gameSelectViewController;
@synthesize gameViewController = gameViewController;
@synthesize gameOverViewController = gameOverViewController;
@synthesize rankViewController = rankViewController;
@synthesize audioPlayer = audioPlayer;
@synthesize soundID = soundID;
@synthesize soundURL = soundURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = YES;
    titleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TitleViewCtr"];
    gameSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameSelectViewCtr"];
    gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewCtr"];
    gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewCtr"];
    rankViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewCtr"];
    self.audioPlayer.delegate = self;
    [ALSdk initializeSdk];
    [self displayContentController:titleViewController];
   
    
}

- (void)moveViewControllerFromTitleViewToRankView{
    [self touchBtnSound];
    [titleViewController timerOff];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:titleViewController];
    titleViewController.delegate = nil;
    [self cycleFromViewController:titleViewController toViewController:rankViewController];
}

- (void)moveViewControllerFromTitleViewToGameSelectView{
    [self touchBtnSound];
    [self stopBGM];
    [titleViewController timerOff];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:titleViewController];
    titleViewController.delegate = nil;
    [gameSelectViewController setChip:[titleViewController getChip]];
    [self cycleFromViewController:titleViewController toViewController:gameSelectViewController];
}

- (void)moveViewControllerFromGameSelectViewToTitleView{
    [self stopBGM];
    [self touchBtnSound2];
    [gameSelectViewController removeStageViews];
    gameSelectViewController.delegate = nil;
    [self cycleFromViewController:gameSelectViewController toViewController:titleViewController];
}

- (void)moveViewControllerFromGameSelectViewToGameViewWithLevel:(int)level Stage:(int)selectedStage{
    [self touchBtnSound];
    [gameSelectViewController removeStageViews];
    gameSelectViewController.delegate = nil;
    gameViewController.stage = [[Stage alloc] initWithLevel:level Number:selectedStage];
    [self cycleFromViewController:gameSelectViewController toViewController:gameViewController];
    
}

- (void)moveViewControllerFromGameViewToGameOverViewWithLevel:(int)level Stage:(int)stage Result:(BOOL)result{
    [self stopBGM];
    for(UIView *n in gameViewController.view.subviews){
        [n removeFromSuperview];
    }
    gameViewController.delegate = nil;
    gameOverViewController.stage = [[Stage alloc] initWithLevel:level Number:stage];
    gameOverViewController.result = result;
    
    [self cycleFromViewController:gameViewController toViewController:gameOverViewController];

}

- (void)moveViewControllerFromGameOverViewToGameSelectView{
    [self touchBtnSound];
    [gameOverViewController removeViews];
    gameOverViewController.delegate = nil;
    [gameSelectViewController setChip:[gameOverViewController getChip]];
    [self cycleFromViewController:gameOverViewController toViewController:gameSelectViewController];

}

- (void)moveViewControllerFromGameOverViewToGameViewWithLevel:(int)level Stage:(int)stage{
    [self touchBtnSound];
    [gameOverViewController removeViews];
    gameOverViewController.delegate = nil;
    gameViewController.stage = [[Stage alloc] initWithLevel:level Number:stage];
    [self cycleFromViewController:gameOverViewController toViewController:gameViewController];
    
}

- (void)moveViewControllerFromGameOverViewToTitleView{
    [self touchBtnSound];
    [gameOverViewController removeViews];
    gameOverViewController.delegate = nil;
    [self cycleFromViewController:gameOverViewController toViewController:titleViewController];
}

- (void)moveViewControllerFromRankViewToTitleView{
    [self touchBtnSound2];
    for(UIView *n in rankViewController.view.subviews){
        [n removeFromSuperview];
    }
    rankViewController.delegate = nil;
    [self cycleFromViewController:rankViewController toViewController:titleViewController];
}


- (void)displayContentController:(UIViewController *)content{
    [self addChildViewController:content];
    [self.view addSubview:content.view];
    
    [content didMoveToParentViewController:self];
}


- (void)hideContentController:(UIViewController *)content{
    
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}


- (void)cycleFromViewController:(UIViewController *)oldC toViewController:(UIViewController *)newC
{
    [oldC willMoveToParentViewController:nil];
    
    [self addChildViewController:newC];
    
    
    [self transitionFromViewController:oldC
                      toViewController:newC
                              duration:0
                               options:0
                            animations:nil
                            completion:^(BOOL finished) {
                                
                                [oldC.view removeFromSuperview];
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                            }];
}

- (void)playTitleBGM{
    if(soundOn){
        if(!self.audioPlayer.isPlaying){
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"findTheCupTitleBGM" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error)
            NSLog(@"Error %@", [error localizedDescription]);
        self.audioPlayer.numberOfLoops = -1;  
        self.audioPlayer.volume = 0.1;
        [self.audioPlayer play];
        }
    }
}

- (void)stopBGM{
    if(self.audioPlayer.isPlaying)
        [self.audioPlayer stop];
}

- (void)playMainBGM{
    if(soundOn){
        if(!self.audioPlayer.playing){
            NSError *error = nil;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"findTheCupMainBGM" ofType:@"mp3"];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (error)
                NSLog(@"Error %@", [error localizedDescription]);
            self.audioPlayer.numberOfLoops = -1;
            self.audioPlayer.volume = 0.1;
            [self.audioPlayer play];
        }
    }

}



- (void)touchBtnSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("decision3"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)touchBtnSound2{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("button05"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
    
}

- (void)cancelSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("cancel1"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
    
}


- (void)shuffleSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("shuffleCup"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
    
}

- (void)countDownSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("countDown"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)timeUpSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("timeUp"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)selectCupSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        self.soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("selectCup"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)chipUpSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL(mainBundle,CFSTR ("coinup"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)chipDownSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL(mainBundle,CFSTR ("chipDown"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (self.soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (self.soundID);
    }
}

- (void)lostSound{
    if(soundOn){
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lostSound" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error)
            NSLog(@"Error %@", [error localizedDescription]);
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 0.7;
        [self.audioPlayer play];

    }
    
}

- (void)wonSound{
    if(soundOn){
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wonSound" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error)
            NSLog(@"Error %@", [error localizedDescription]);
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 0.7;
        [self.audioPlayer play];

    }
}

- (void)setSoundOn:(BOOL)on{
    soundOn = on;
}

- (BOOL)getSoundOn{
    return soundOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

