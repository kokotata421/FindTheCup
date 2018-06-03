//
//  GameOverViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/06/12.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "GameOverViewController.h"
#import "NCMB.h"
#import "NCMBFile.h"
#import "NCMBObject.h"
#import "ViewController.h"



@interface GameOverViewController (){
    CGSize resultViewSize;
    NSArray *levelStrings;
    NSUserDefaults *ud;
    NSMutableArray *stageRecord;
    NSArray *chipNumberViews;
    NSString *resultString;
    int chipCount;
    NSTimer *tm;
    UIImageView * yourChipView;
}



@end

@implementation GameOverViewController


static NSString* kGameOverViewImage = @"GameOverView";
static NSString* kRetryBtnImage = @"RetryBtn";
static NSString* kNextBtnImage = @"NextBtn";
static NSString* kTitleBtnImage = @"TitleBtn";
static NSString* kStageBtnImage = @"StageBtn";
static NSString* kYouWonImage = @"YouWon";
static NSString* kYouLostImage = @"YouLost";
static NSString* kWonChipImage = @"WonChip";
static NSString* kLostChipImage = @"LostChip";
static NSString* kNumber0 = @"NumberOfGameOverView_0";
static NSString* kNumber1 = @"NumberOfGameOverView_1";
static NSString* kNumber2 = @"NumberOfGameOverView_2";
static NSString* kNumber3 = @"NumberOfGameOverView_3";
static NSString* kNumber4 = @"NumberOfGameOverView_4";
static NSString* kNumber5 = @"NumberOfGameOverView_5";
static NSString* kNumber6 = @"NumberOfGameOverView_6";
static NSString* kNumber7 = @"NumberOfGameOverView_7";
static NSString* kNumber8 = @"NumberOfGameOverView_8";
static NSString* kNumber9 = @"NumberOfGameOverView_9";
static NSString* kYourChipImage = @"YourChipOfGameOverView";

static NSString* kErrorTitle = @"Couldn't record your chip";

static float chipSizeToWidth = 0.2604;
static float chipYScale = 0.0915;
static sizeScale resultViewScale = {0.6, 0.14};
static float resultViewYScale = 0.02;
static sizeScale btnSizeScale = {0.267, 0.145};
static float retryBtnYScale = 0.67;
static float numberWidthScale = 0.038;
static float numberHeightScale = 0.1;
static float numberYScale = 0.3253;
static float numberXScale1[2] = {0.501, 0.4578};
static float numberXScale2[3] = {0.5228 ,0.4795, 0.4361};
static float numberXScale3[4] = {0.543 ,0.4998, 0.4564, 0.413};
static float numberXScale4[5] = {0.5647, 0.5213 ,0.4779, 0.4347, 0.3912};
static float yourChipYScale = 0.2;
static float yourChipWidthScale = 0.31;
static float yourChipHeightScale = 0.08;


static BOOL resultProcedureDone = NO;
static CGSize referenceSize;

static int chip;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self gameOverViewSetUp];
    referenceSize = _gameOverView.frame.size;
    levelStrings = [[NSArray alloc] initWithObjects: @"BEGINNER", @"INTERMEDIATE", @"ADVANCED", nil];
}


- (void)viewDidAppear:(BOOL)animated{
    if(!resultProcedureDone){
        self.delegate = (ViewController *)self.parentViewController;
        resultString = (self.result) ? @"SuccessChip" : @"FailureChip";
        self.resultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(self.result) ? kYouWonImage : kYouLostImage]];
        resultViewSize = CGSizeMake(referenceSize.width * resultViewScale.width, referenceSize.height * resultViewScale.height);
        self.resultView.frame = CGRectMake(referenceSize.width / 2.0 - resultViewSize.width / 2.0,0.0 - resultViewSize.height * 2.0, resultViewSize.width, resultViewSize.height);
        [self.view addSubview:self.resultView];
        [self chipViewSetUp];
        [self setUpChip];
        [self updateStageRecord];
        self.interstitial = [self adLoad];
        [self resultSound];
        [self resultViewAnimation];
        [self showBanner];
    }
    resultProcedureDone = NO;
}

- (GADInterstitial *)adLoad{
    GADRequest *request = [GADRequest request];
    

    GADInterstitial* interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8719818866106636/2123551300"];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    resultProcedureDone = YES;
    [self adLoad];
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    resultProcedureDone = YES;
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView{
    [self.bannerView removeFromSuperview];
    [self showBanner];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView{
    resultProcedureDone = YES;
}

- (void)resultSound{
    if(self.result)
        [self.delegate wonSound];
    else
        [self.delegate lostSound];
}

- (void)setUpChip{
    ud = [NSUserDefaults standardUserDefaults];
    NSNumber *chipNumber = [ud objectForKey:@"Chip"];
    chip = [chipNumber intValue];
}

- (void)gameOverViewSetUp{
    
    self.gameOverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGameOverViewImage]];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.gameOverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
    else
        self.gameOverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90.0);
    [self.view addSubview:self.gameOverView];
}



- (void)setUpBtn{
    CGSize btnSize = CGSizeMake(referenceSize.width * btnSizeScale.width, referenceSize.height * btnSizeScale.height);
    self.retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - btnSize.width / 2.0, referenceSize.height * retryBtnYScale, btnSize.width, btnSize.height)];
    [self.retryBtn setImage:[UIImage imageNamed:(self.result) ? kNextBtnImage : kRetryBtnImage] forState:UIControlStateNormal];
    if(self.result && self.stage.level == 2 && self.stage.numberOfStage == 23)
        [self.retryBtn setImage:[UIImage imageNamed:kRetryBtnImage] forState:UIControlStateNormal];
    self.retryBtn.userInteractionEnabled = YES;
    [self.retryBtn addTarget:self action:(self.result)? @selector(next) : @selector(retry) forControlEvents:UIControlEventTouchUpInside];
    if(self.result && self.stage.level == 2 && self.stage.numberOfStage == 23){
        [self.retryBtn removeTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.retryBtn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.retryBtn];
    
    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake((referenceSize.width / 2.0) - btnSize.width - referenceSize.width * 0.003, referenceSize.height * retryBtnYScale + btnSize.height + referenceSize.width * 0.006, btnSize.width, btnSize.height)];
    [self.titleBtn setImage:[UIImage imageNamed:kTitleBtnImage] forState:UIControlStateNormal];
    [self.titleBtn addTarget:self.delegate action:@selector(moveViewControllerFromGameOverViewToTitleView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.titleBtn];
    
    
    self.stageBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 + referenceSize.width * 0.003, referenceSize.height * retryBtnYScale + btnSize.height + referenceSize.width * 0.006, btnSize.width, btnSize.height)];
    [self.stageBtn setImage:[UIImage imageNamed:kStageBtnImage] forState:UIControlStateNormal];
    [self.stageBtn addTarget:self.delegate action:@selector(moveViewControllerFromGameOverViewToGameSelectView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.stageBtn];
}

- (void)resultViewAnimation{
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.resultView.layer.zPosition = 2.0;
        self.resultView.frame = CGRectMake(referenceSize.width / 2.0 - resultViewSize.width / 2.0, referenceSize.height * resultViewYScale, resultViewSize.width, resultViewSize.height);
    }completion:^(BOOL finished){
        [self showYourChip];
        [self updateChipNumber:self.result];
    }];
}

- (void)showYourChip{
    CGSize yourChipSize = CGSizeMake(referenceSize.width * yourChipWidthScale, referenceSize.height * yourChipHeightScale);
    CGRect yourChipRect = CGRectMake(referenceSize.width / 2.0 - yourChipSize.width / 2.0, referenceSize.height * yourChipYScale, yourChipSize.width, yourChipSize.height);
    yourChipView = [[UIImageView alloc] initWithFrame:yourChipRect];
    yourChipView.image = [UIImage imageNamed:kYourChipImage];
    [self.view addSubview:yourChipView];
    
}

- (void)chipViewSetUp{
    self.chipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(self.result) ? @"WonChip" : @"LostChip"]];
    CGSize chipSize = CGSizeMake(referenceSize.width * chipSizeToWidth, referenceSize.width * chipSizeToWidth);
    self.chipView.frame = CGRectMake(referenceSize.width / 2.0 - chipSize.width / 2.0, referenceSize.height * chipYScale, chipSize.width, chipSize.height);
    [self.view addSubview:self.chipView];
}


- (void)retry{
    if(chip >= self.stage.bet)
        [self.delegate moveViewControllerFromGameOverViewToGameViewWithLevel:self.stage.level Stage:self.stage.numberOfStage];
    else
        [self.delegate cancelSound];
}

- (void)next{
    if(self.stage.numberOfStage + 1 < 23)
        [self.delegate moveViewControllerFromGameOverViewToGameViewWithLevel:self.stage.level Stage:self.stage.numberOfStage + 1];
    else
        [self.delegate moveViewControllerFromGameOverViewToGameViewWithLevel:self.stage.level + 1 Stage:1];
}



- (void)updateChipNumber:(BOOL)result{
    [self setChipNumberView:chip];
    if(result){
        chipCount = self.stage.paysOff;
        float interval;
        if(self.stage.paysOff > 20)
            interval = 0.12;
        else if(self.stage.paysOff > 10)
            interval = 0.17;
        else
            interval = 0.2;
        
        tm = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateChipNumber) userInfo:nil repeats:YES];
    }else{
        chipCount = self.stage.bet;
        tm = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateChipNumber) userInfo:nil repeats:YES];
    }
}

- (void)updateChipNumber{
    for(int i = 0; i < chipNumberViews.count; i++){
            UIImageView * chipView = chipNumberViews[i];
            [chipView removeFromSuperview];
    }
    if(self.result){
        chip++;
        [self.delegate chipUpSound];
    }else{
        chip--;
        [self.delegate chipDownSound];
    }
    chipCount--;
    [self setChipNumberView:chip];
    if(chipCount < 1){
        [tm invalidate];
        [self updateChipRecord];
    }
}



- (void)setChipNumberView:(int)chip{
    if(chip >= 10000)
        [self setChipViewOfFiveDigit:chip];
    else if(chip >= 1000)
        [self setChipViewOfFourDigit:chip];
    else if(chip >= 100)
        [self setChipViewOfThreeDigit:chip];
    else if(chip >= 10)
        [self setChipViewOfTwoDigit:chip];
    else
        [self setChipViewOfOneDigit:chip];
}

- (void)setChipViewOfFiveDigit:(int)chip{
    int temp = chip;
    NSMutableArray *chipNumberView = [NSMutableArray array];
    for(int i = 0; i < 5; i++){
        int number;
        number = temp % 10;
        NSString *str = [NSString stringWithFormat:@"NumberOfGameOverView_%d", number];
        UIImageView* numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        CGRect rect;
        rect = CGRectMake(referenceSize.width * numberXScale4[i], referenceSize.height * numberYScale, referenceSize.width * numberWidthScale, referenceSize.height * numberHeightScale);
        numberView.frame = rect;
        [self.view addSubview:numberView];
        temp /= 10;
        [chipNumberView addObject:numberView];
    }
    chipNumberViews = [[NSArray alloc] initWithArray:chipNumberView];
}

- (void)setChipViewOfFourDigit:(int)chip{
    int temp = chip;
    NSMutableArray *chipNumberView = [NSMutableArray array];
    for(int i = 0; i < 4; i++){
        int number;
        number = temp % 10;
        NSString *str = [NSString stringWithFormat:@"NumberOfGameOverView_%d", number];
        UIImageView* numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        CGRect rect;
        rect = CGRectMake(referenceSize.width * numberXScale3[i], referenceSize.height * numberYScale, referenceSize.width * numberWidthScale, referenceSize.height * numberHeightScale);
        numberView.frame = rect;
        [self.view addSubview:numberView];
        temp /= 10;
        [chipNumberView addObject:numberView];
    }
    chipNumberViews = [[NSArray alloc] initWithArray:chipNumberView];
}

- (void)setChipViewOfThreeDigit:(int)chip{
    int temp = chip;
    NSMutableArray *chipNumberView = [NSMutableArray array];
    for(int i = 0; i < 3; i++){
        int number;
        number = temp % 10;
        NSString *str = [NSString stringWithFormat:@"NumberOfGameOverView_%d", number];
        UIImageView* numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        CGRect rect;
        rect = CGRectMake(referenceSize.width * numberXScale2[i], referenceSize.height * numberYScale, referenceSize.width * numberWidthScale, referenceSize.height * numberHeightScale);
        numberView.frame = rect;
        [self.view addSubview:numberView];
        temp /= 10;
        [chipNumberView addObject:numberView];
    }
    chipNumberViews = [[NSArray alloc] initWithArray:chipNumberView];
}

- (void)setChipViewOfTwoDigit:(int)chip{
    int temp = chip;
    NSMutableArray *chipNumberView = [NSMutableArray array];
    for(int i = 0; i < 2; i++){
        int number;
        number = temp % 10;
        NSString *str = [NSString stringWithFormat:@"NumberOfGameOverView_%d", number];
        UIImageView* numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        CGRect rect;
        rect = CGRectMake(referenceSize.width * numberXScale1[i], referenceSize.height * numberYScale, referenceSize.width * numberWidthScale, referenceSize.height * numberHeightScale);
        numberView.frame = rect;
        [self.view addSubview:numberView];
        temp /= 10;
        [chipNumberView addObject:numberView];
    }
    chipNumberViews = [[NSArray alloc] initWithArray:chipNumberView];
}

- (void)setChipViewOfOneDigit:(int)chip{
    int temp = chip;
    NSMutableArray *chipNumberView = [NSMutableArray array];
    
    int number;
    number = temp % 10;
    NSString *str = [NSString stringWithFormat:@"NumberOfGameOverView_%d", number];
    UIImageView* numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
    [self.view addSubview:numberView];
    temp /= 10;
    [chipNumberView addObject:numberView];
    CGSize numberSize = CGSizeMake(referenceSize.width * numberWidthScale, referenceSize.height * numberHeightScale);
    CGRect numberRect = CGRectMake(referenceSize.width / 2.0 - numberSize.width / 2.0, referenceSize.height * numberYScale, numberSize.width, numberSize.height);
    numberView.frame = numberRect;
    chipNumberViews = [[NSArray alloc] initWithArray:chipNumberView];
}

- (void)updateStageRecord{
    if(!self.result){
        return;
    }
    ud = [NSUserDefaults standardUserDefaults];
    stageRecord = [[NSMutableArray alloc] initWithArray:[ud objectForKey:levelStrings[self.stage.level]]];
    stageRecord[self.stage.numberOfStage] = @(YES);
    [ud setObject:stageRecord forKey:levelStrings[self.stage.level]];
    [ud synchronize];
}

- (void)updateChipRecord{
    ud = [NSUserDefaults standardUserDefaults];
    NSString* name = [ud objectForKey:@"Name"];
    NSNumber *chipNumber = [NSNumber numberWithInt:chip];
    
    [ud setObject:chipNumber forKey:@"Chip"];
    [ud synchronize];
    [self updateChipRecordOnRank:name];
    if(chip < 5 && [[ud objectForKey:@"Count"] boolValue] == NO)
        [self recordBeginingTime];
}

- (void)recordBeginingTime{
    ud = [NSUserDefaults standardUserDefaults];
    NSDate *date = [NSDate date];
    [ud setObject:date forKey:@"BeginingTime"];
    [ud setObject:@(YES) forKey:@"Count"];
    [ud synchronize];
}

- (void)updateChipRecordOnRank:(NSString *)name{
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    [query whereKey:@"name" equalTo:name];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSString *title = NSLocalizedString(@"error", @"");
            NSString *message = NSLocalizedString(@"Couldn't record your chip", @"");
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                return;
            }];
            oKAction.enabled = YES;
            
            [alertController addAction:oKAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:^{
                                 [self setUpBtn];
                             }];
        } else {
            NCMBObject *object = objects[0];
            NSNumber *chipNumber = [NSNumber numberWithInt:chip];
            [object setObject:chipNumber forKey:@"chip"];
            [object saveInBackgroundWithBlock:^(NSError *error) {
                if (error){
                    NSString *title = NSLocalizedString(@"error", @"");
                    NSString *message = NSLocalizedString(@"Couldn't record your chip", @"");                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        return;
                    }];
                    oKAction.enabled = YES;
                    
                    [alertController addAction:oKAction];
                    [self presentViewController:alertController
                                       animated:YES
                                     completion:^{
                                         [self setUpBtn];
                                     }];
                } else {
                    [self setUpBtn];
                    if(arc4random_uniform(3) == 0)
                        [self.interstitial presentFromRootViewController:self];
                }
            }];
        }
    }];
}


- (int)getChip{
    return chip;
}

- (void)removeViews{
    [self.chipView removeFromSuperview];
    [self.resultView removeFromSuperview];
    [self.resultView removeFromSuperview];
    [self.retryBtn removeFromSuperview];
    [self.stageBtn removeFromSuperview];
    [self.titleBtn removeFromSuperview];
    for(UIImageView *n in chipNumberViews){
        [n removeFromSuperview];
    }
    [yourChipView removeFromSuperview];
}



- (void)showBanner{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/5077017704";
    }else{
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/4878541307";
        
    }
    
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:request];
    
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
