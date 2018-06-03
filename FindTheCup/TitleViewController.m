//
//  TitleViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/09/22.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "TitleViewController.h"
#import "Check.h"
#import "NCMB.h"
#import "NCMBFile.h"
#import "NCMBObject.h"
#import "SVProgressHUD.h"
#import "ViewController.h"

@interface TitleViewController (){
    NSUserDefaults* ud;
    int presentExplanationPage;
    UIView *loadingView;
    NSArray *secViewArray;
    NSArray *minViewArray;
}


@property(assign) int count;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) UIView *blackCover;
@property(strong, nonatomic) UIImageView *presentExplanationView;
@property(strong, nonatomic) UIImageView *presentPageNumberView;
@property(strong, nonatomic) UIButton *nextArrowBtn;
@property(strong, nonatomic) UIButton *backArrowBtn;
@property(strong, nonatomic) UIButton *backBtn;
@property(strong, nonatomic) UIImageView *countDownFrame;
@property(strong, nonatomic) NSArray *currentChipViews;
@property(strong, nonatomic) UIImageView *adExplanationView;
@property(strong, nonatomic) UIButton *resumeAdBtn;
@property(strong, nonatomic) UIImageView *adCountNumberView;
@property(strong, nonatomic) UIButton *adCancelbtn;
@property(assign) BOOL showingAdExplanation;

@end

static NSString* kPlayerName = @"PlayerName";
static NSString* kTextViewTitle = @"PlayerName";
static NSString* kTextViewMessage = @"Message";
static NSString* kPlaceHolderMessage = @"Enter Your Name";
static NSString* kTooManyCharacter = @"Too many character";
static NSString* kTooManyCharacterMessage = @"Please type 16 characters or less";
static NSString* kAlertFirstLetter = @"First letter is not alphabet";
static NSString* kAlertFirstLetterMessage = @"First letter must be alphabet";
static NSString* kAlertAlphaNumericSymbol = @"Your name includes an unacceptable character";
static NSString* kAlertAlphaNumericSymbolMessage = @"Please enter your name with only Alphanumeric and Symbol characters";
static NSString* kAlertNameIsAlreadyRegistered = @"That name is already registered";
static NSString* kAlertNameIsAlreadyRegisteredMessage = @"That name is already registered.Please type different name";
static NSString* kErrorTitle = @"Couldn't record your chip";
//Scales of Size and Point




static const sizeScale countNumberSizeScaleToFrame = {0.1156, 0.6111};
static const sizeScale countNumber1SizeScaleToFrame = {0.1062, 0.6111};
static const float countMinuteXScaleToFrame[2] = {0.4443, 0.3099};
static const float countSecondXScaleToFrame[2] = {0.8099 ,0.6756};
static const scale countColonScaleToFrame = {0.5975, 0.2777, 0.04062, 0.444};
static const float squareBtnSizeScale = 0.1064;
static const float intervalScaleOfSquareBtnToWidth = 0.0226;

static const int minimumLengthOfName = 1;
static const int maximumLengthOfName = 16;

static BOOL needOfSetup = YES;
static BOOL showingAdExView = NO;
static BOOL gotChipByAd = NO;

static int adCount;

static CGSize referenceSize;


static const int defaultChipCount = 5;

static int chip;

@implementation TitleViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureTitleView];
    if(referenceSize.width)
        [self showBtn];
    [self prepareExplanation];
    [GADMobileAds initialize];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    self.delegate = (ViewController *)self.parentViewController;
    [self.delegate playTitleBGM];
    if(needOfSetup){
        [self configureSoundBtnImage];
        
        if(![self hasPlayerName]){
            [self showAlertController];
        }
        else{
            
            [self showPresentChip];
        }
        [self showBanner];
    }
    needOfSetup = YES;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(enterFromBackground) name:@"enterFromBackground" object:nil];
    [nc addObserver:self selector:@selector(enterBackground) name:@"enterBackground" object:nil];

}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView{
    [self.bannerView removeFromSuperview];
    [self showBanner];
}



- (void)showAlertController{
    
    NSString *title = NSLocalizedString(kTextViewTitle, @"");
    NSString *message = NSLocalizedString(kTextViewMessage, @"");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField* textField = alertController.textFields.firstObject;
        [self checkType:textField];
    }];
    okAction.enabled = NO;
    
    [alertController addAction:okAction];
    
    NSString *placeHolder = NSLocalizedString(kPlaceHolderMessage, @"");
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeHolder;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeySend;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [self presentViewController:alertController
                       animated:NO
                     completion:nil];
    
    
}


- (void)configureTitleView{
    NSString* kTitleView = @"FindTheCupTitleView";
    
    self.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kTitleView]];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
        else
            self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90.0);
            [self.view addSubview:self.titleView];
    
    referenceSize = self.titleView.frame.size;
    
}

- (void)showBtn{
    NSString* kPlayBtnImage = @"PlayBtn";
    NSString* kHowToPlayBtnImage = @"HowToPlayBtn";
    NSString* kRankBtnImage = @"RankBtn";
    
    
    sizeScale btnSizeScale = {0.267, 0.145};
    float playBtnYScale = 0.67;
    
    CGSize btnSize = CGSizeMake(referenceSize.width * btnSizeScale.width, referenceSize.height * btnSizeScale.height);
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.titleView.frame.size.width / 2.0 - btnSize.width / 2.0, self.titleView.frame.size.height * playBtnYScale, btnSize.width, btnSize.height)];
    [self.playBtn setImage:[UIImage imageNamed:kPlayBtnImage] forState:UIControlStateNormal];
    self.playBtn.userInteractionEnabled = YES;
    [self.playBtn addTarget:self.delegate action:@selector(moveViewControllerFromTitleViewToGameSelectView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.playBtn];
    
    self.howToPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - btnSize.width - referenceSize.width * 0.003, referenceSize.height * playBtnYScale + btnSize.height + referenceSize.width * 0.006, btnSize.width, btnSize.height)];
    [self.howToPlayBtn setImage:[UIImage imageNamed:kHowToPlayBtnImage] forState:UIControlStateNormal];
    [self.howToPlayBtn addTarget:self action:@selector(showExplanation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.howToPlayBtn];
    
    self.rankBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 + referenceSize.width * 0.003, referenceSize.height * playBtnYScale + btnSize.height + referenceSize.width * 0.006, btnSize.width, btnSize.height)];
    [self.rankBtn setImage:[UIImage imageNamed:kRankBtnImage] forState:UIControlStateNormal];
    [self.rankBtn addTarget:self.delegate action:@selector(moveViewControllerFromTitleViewToRankView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.rankBtn];
    
    float soundBtnSize = referenceSize.width * squareBtnSizeScale;
    self.soundBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width * intervalScaleOfSquareBtnToWidth, referenceSize.height - soundBtnSize - (referenceSize.height * intervalScaleOfSquareBtnToWidth), soundBtnSize, soundBtnSize)];
    [self.soundBtn addTarget:self action:@selector(switchSoundOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.soundBtn];
    
}

- (void)configureSoundBtnImage{
    NSString* kSoundOnImage = @"SoundOn";
    NSString* kSoundOffImage = @"SoundOff";
    ViewController *parentCtr = (ViewController *)self.parentViewController;
    
    if([parentCtr getSoundOn])
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOnImage] forState:UIControlStateNormal];
    else
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOffImage] forState:UIControlStateNormal];
}


- (void)switchSoundOn{
    ViewController *parentCtr = (ViewController *)self.parentViewController;
    [parentCtr setSoundOn:![parentCtr getSoundOn]];
    if([parentCtr getSoundOn]){
        [self configureSoundBtnImage];
        [self.delegate playTitleBGM];
    } else{
        [self configureSoundBtnImage];
        [self.delegate stopBGM];
    }
}



- (void)prepareExplanation{
    NSString* kBackBtnImage = @"BackBtn";
    NSString* kNextArrowImage = @"NextArrow";
    NSString* kBackArrowImage = @"BackArrow";
    
    
    float arrowWidthScale = 0.1;
    float arrowHeigthtScale = 0.7407;
    float arrowYScale = 0.2592;
    
    sizeScale explanationSizeScale = {0.8, 0.905};
    float pageNumberYScale = 0.89;
    sizeScale pageNumberSizeScale = {0.045, 0.048};
    scale backBtnScale = {0.8137, 0.835, 0.1268, 0.0925};
    
    presentExplanationPage = 1;
    self.blackCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, referenceSize.width, referenceSize.height)];
    self.blackCover.backgroundColor = [UIColor blackColor];
    self.blackCover.alpha = 0.8;
    self.blackCover.userInteractionEnabled = YES;
    self.blackCover.layer.zPosition = 1.0;
    
    NSString *string = [[NSString alloc] initWithFormat:@"Explanation%d", presentExplanationPage];
    NSString *image = NSLocalizedString(string, @"");
    self.presentExplanationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    CGSize explanationSize = CGSizeMake(referenceSize.width * explanationSizeScale.width, referenceSize.height * explanationSizeScale.height);
    self.presentExplanationView.frame = CGRectMake(referenceSize.width / 2.0 - explanationSize.width / 2.0, referenceSize.height / 2.0 - explanationSize.height / 2.0, explanationSize.width , explanationSize.height);
    self.presentExplanationView.userInteractionEnabled = YES;
    self.presentExplanationView.layer.zPosition = 1.5;
    
    self.nextArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width - referenceSize.width * arrowWidthScale, referenceSize.height * arrowYScale, referenceSize.width * arrowWidthScale, referenceSize.height * arrowHeigthtScale)];
    [self.nextArrowBtn setImage:[UIImage imageNamed:kNextArrowImage] forState:UIControlStateNormal];
    [self.nextArrowBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    self.nextArrowBtn.userInteractionEnabled = YES;
    self.nextArrowBtn.layer.zPosition = 1.5;
    
    self.backArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, referenceSize.height * arrowYScale, referenceSize.width * arrowWidthScale, referenceSize.height * arrowHeigthtScale)];
    [self.backArrowBtn setImage:[UIImage imageNamed:kBackArrowImage] forState:UIControlStateNormal];
    [self.backArrowBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    self.backArrowBtn.userInteractionEnabled = YES;
    self.backArrowBtn.layer.zPosition = 1.5;
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.presentExplanationView.frame.size.width * backBtnScale.x, self.presentExplanationView.frame.size.height * backBtnScale.y, referenceSize.width * backBtnScale.width, referenceSize.height * backBtnScale.height)];
    [self.backBtn setImage:[UIImage imageNamed:kBackBtnImage] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.userInteractionEnabled = YES;
    
    self.presentPageNumberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[NSString alloc] initWithFormat:@"PageNumber%d", presentExplanationPage]]];
    CGSize pageNumberSize = CGSizeMake(referenceSize.width * pageNumberSizeScale.width, referenceSize.height * pageNumberSizeScale.height);
    self.presentPageNumberView.frame = CGRectMake(self.presentExplanationView.frame.size.width / 2.0 - pageNumberSize.width / 2.0, self.presentExplanationView.frame.size.height * pageNumberYScale, pageNumberSize.width, pageNumberSize.height);
    
}

- (void)showExplanation{
    [self.delegate touchBtnSound];
    presentExplanationPage = 1;
    NSString *string = [[NSString alloc] initWithFormat:@"Explanation%d", presentExplanationPage];
    NSString *image = NSLocalizedString(string, @"");
    self.presentExplanationView.image = [UIImage imageNamed:image];
    self.presentPageNumberView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"PageNumber%d", presentExplanationPage]];
    self.playBtn.userInteractionEnabled = NO;
    self.howToPlayBtn.userInteractionEnabled = NO;
    self.rankBtn.userInteractionEnabled = NO;
    self.soundBtn.userInteractionEnabled = NO;
    self.chipAdBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.blackCover];
    [self.view addSubview:self.presentExplanationView];
    [self.presentExplanationView addSubview:self.backBtn];
    [self.presentExplanationView addSubview:self.presentPageNumberView];
    [self showArrow];
}

- (void)nextPage{
    [self.delegate touchBtnSound2];
    presentExplanationPage++;
    NSString *string = [[NSString alloc] initWithFormat:@"Explanation%d", presentExplanationPage];
    NSString *image = NSLocalizedString(string, @"");
    self.presentExplanationView.image = [UIImage imageNamed:image];
    self.presentPageNumberView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"PageNumber%d", presentExplanationPage]];
    
    [self.presentExplanationView addSubview:self.backBtn];
    [self.presentExplanationView addSubview:self.presentPageNumberView];
    [self showArrow];
}



- (void)backPage{
    [self.delegate touchBtnSound2];
    presentExplanationPage--;
    NSString *string = [[NSString alloc] initWithFormat:@"Explanation%d", presentExplanationPage];
    NSString *image = NSLocalizedString(string, @"");
    self.presentExplanationView.image = [UIImage imageNamed:image];
    self.presentPageNumberView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"PageNumber%d", presentExplanationPage]];
    [self.presentExplanationView addSubview:self.backBtn];
    [self.presentExplanationView addSubview:self.presentPageNumberView];
    [self showArrow];
}

- (void)showArrow{
    [self.nextArrowBtn removeFromSuperview];
    [self.backArrowBtn removeFromSuperview];
    switch(presentExplanationPage){
        case 1: [self showNextArrow]; break;
        case 2: [self showBothArrows]; break;
        case 3: [self showBackArrow]; break;
        default: break;
    }
}

- (void)showBothArrows{
    [self showBackArrow];
    [self showNextArrow];
}

- (void)showNextArrow{
    [self.view addSubview:self.nextArrowBtn];
}

- (void)showBackArrow{
    [self.view addSubview:self.backArrowBtn];
}

- (void)backHome{
    [self.delegate touchBtnSound2];
    [self.nextArrowBtn removeFromSuperview];
    [self.backArrowBtn removeFromSuperview];
    [self.blackCover removeFromSuperview];
    [self.presentExplanationView removeFromSuperview];
    
    self.playBtn.userInteractionEnabled = YES;
    self.howToPlayBtn.userInteractionEnabled = YES;
    self.rankBtn.userInteractionEnabled = YES;
    self.soundBtn.userInteractionEnabled = YES;
    self.chipAdBtn.userInteractionEnabled = YES;
}


- (BOOL)hasPlayerName{
    
    ud = [NSUserDefaults standardUserDefaults];
    self.playerName = [ud objectForKey:@"Name"];
    if(self.playerName != nil)
        return YES;
    else
        return NO;
}

- (BOOL)checkType:(UITextField *)textField{
    
    NSString* text = textField.text;
    
    NSString* firstLetter = [text substringWithRange:NSMakeRange(0, 1)];
    if(![Check chkAlphabet:firstLetter]){
        NSString* alertTitle = NSLocalizedString(kAlertFirstLetter, @"");
        NSString* alertMessage = NSLocalizedString(kAlertFirstLetterMessage, @"");
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAlertController];
        }]];
        
        [self presentViewController:alertController
                           animated:NO
                         completion:nil];
        
        
        return YES;
    }
    
    if(![Check chkAlphaNumericSymbol:text]){
        NSString* alertTitle = NSLocalizedString(kAlertAlphaNumericSymbol, @"");
        NSString* alertMessage = NSLocalizedString(kAlertAlphaNumericSymbolMessage, @"");
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAlertController];
        }]];
        
        [self presentViewController:alertController
                           animated:NO
                         completion:nil];
        
        return YES;
    }
    
    if([self nameAlreadyExists:text]){
        NSString* alertTitle = NSLocalizedString(kAlertNameIsAlreadyRegistered, @"");
        NSString* alertMessage = NSLocalizedString(kAlertNameIsAlreadyRegisteredMessage, @"");
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAlertController];
        }]];
        
        [self presentViewController:alertController
                           animated:NO
                         completion:^{
                         }];
        
        return YES;
        
    }
    
    [self registerPlayerName:text];
    
    return YES;
}

- (BOOL)nameAlreadyExists:(NSString*)text{
    
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    NSError *error;
    [query whereKey:@"name" equalTo:text];
    
    NCMBObject* n = [query getFirstObject:&error];
    if(error != nil) {
        return YES;
    }else {
        if([[n objectForKey:@"name"] isEqualToString:text])
            return YES;
        else
            return NO;
    }
   
    
}


- (void)registerPlayerName:(NSString*)name{
    NSNumber* chipNumber = [[NSNumber alloc] initWithInt:5];
    
    NCMBObject *object = [NCMBObject objectWithClassName:@"Rank"];
    [object setObject:name forKey:@"name"];
    [object setObject:chipNumber forKey:@"chip"];
    
    [object saveEventually:^(NSError *error) {
        if (!error){
            self.playerName = name;
            ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:name forKey:@"Name"];
            [ud setObject:chipNumber forKey:@"Chip"];
            [ud synchronize];
            [self showPresentChip];
        } else {
            NSString *title = NSLocalizedString(@"error", @"");
            NSString *message = NSLocalizedString(@"Couldn't record your name", @"");
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                return;
            }];
            okAction.enabled = YES;
            
            [alertController addAction:okAction];
            [self presentViewController:alertController
                               animated:NO
                             completion:^{
                                 [self showAlertController];
                             }];

        }
    }];
     
    
    
}

- (void)showPresentChip{
    NSString* kYourChipImage = @"YourChip_TitleView";
    
    scale yourChipScale = {0.675, 0.0263,0.3079, 0.08};
    ud = [NSUserDefaults standardUserDefaults];
    NSNumber *chipNumber = [ud objectForKey:@"Chip"];
    if(chipNumber != nil)
        chip = [chipNumber intValue];
    else
        return;
    self.yourChipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kYourChipImage]];
    self.yourChipView.frame = CGRectMake(referenceSize.width * yourChipScale.x, referenceSize.height * yourChipScale.y, referenceSize.width * yourChipScale.width, referenceSize.height * yourChipScale.height);
    [self.view addSubview:self.yourChipView];
    [self removeChipNumberView];
    [self addChipNumberView];
    [self canAddChip];
}



- (void)textFieldEditingChanged:(UITextField *)textField{
    NSString *text = textField.text;
    
    if(text.length < minimumLengthOfName || text.length > maximumLengthOfName){
        UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = NO;
    }else{
        UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSString *text = textField.text;
    if(text.length < minimumLengthOfName || text.length > maximumLengthOfName)
        return NO;
    else
        return [self checkType:textField];
}



- (void)canAddChip{
    if(chip >= defaultChipCount){
        for(UIView *n in self.countDownFrame.subviews){
            [n removeFromSuperview];
        }
        [self.countDownFrame removeFromSuperview];
        [self.chipAdBtn removeFromSuperview];
        return;
    }else {
        ud = [NSUserDefaults standardUserDefaults];
        NSDate *now = [NSDate date];
        NSDate *lastTime = [ud objectForKey:@"BeginingTime"];
        float tmp = [now timeIntervalSinceDate:lastTime];
        int addingChipCount = (int)tmp / (60 * 15);
        if(addingChipCount){
            [self addChip:addingChipCount];
            if(chip >= defaultChipCount){
                [self.chipAdBtn removeFromSuperview];
                for(UIView *n in self.countDownFrame.subviews){
                    [n removeFromSuperview];
                }
                [self.countDownFrame removeFromSuperview];
                [ud setObject:@(NO) forKey:@"Count"];
            }
            [self removeChipNumberView];
            [self addChipNumberView];
            [ud setObject:now forKey:@"BeginingTime"];
        }
        
        if(chip < defaultChipCount){
            self.count = (60 * 15) - ((int)tmp % (60 * 15));
            if(!showingAdExView){
                [self configureRewardedAd];
                [self.view addSubview:self.chipAdBtn];
            }
            for(UIView *n in self.countDownFrame.subviews){
                [n removeFromSuperview];
            }
            [self.countDownFrame removeFromSuperview];
            [self startTimer:self.count];
        }
    }
}

- (void)startTimer:(int)time{
    if([self.timer isValid])
        return;
    NSString* kFrameImage = @"FrameOfCount";
    NSString* kColonImage = @":ForCount";
    NSString* kCountChipIconImage = @"SuccessChip";
    
    scale frameOfCountScale = {0.7, 0.139, 0.16666, 0.09};
    float countChipIconSizeScaleToFrameWidth = 0.22;
    float countChipIconXpointScaleToFrame = 0.0156;
    
    int min = time / 60;
    int sec = time % 60;
    self.countDownFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFrameImage]];
    self.countDownFrame.frame = CGRectMake(referenceSize.width * frameOfCountScale.x, referenceSize.height * frameOfCountScale.y, referenceSize.width * frameOfCountScale.width, referenceSize.height * frameOfCountScale.height);
    [self.view addSubview:self.countDownFrame];
    UIImageView *countChipIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCountChipIconImage]];
    float chipIconSize = self.countDownFrame.frame.size.width * countChipIconSizeScaleToFrameWidth;
    countChipIconView.frame = CGRectMake(self.countDownFrame.frame.size.width * countChipIconXpointScaleToFrame, self.countDownFrame.frame.size.height / 2.0 - chipIconSize / 2.0, chipIconSize, chipIconSize);
    [self.countDownFrame addSubview:countChipIconView];
    UIImageView *colonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kColonImage]];
    colonView.frame = CGRectMake(self.countDownFrame.frame.size.width * countColonScaleToFrame.x, self.countDownFrame.frame.size.height * countColonScaleToFrame.y, self.countDownFrame.frame.size.width * countColonScaleToFrame.width, self.countDownFrame.frame.size.height * countColonScaleToFrame.height);
    [self.countDownFrame addSubview:colonView];
    [self showCount:min sec:sec];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

- (void)countDown{
    self.count--;
    int sec = self.count % 60;
    int min = self.count / 60;
    [self showCount:min sec:sec];
    
    if(self.count < 1){
        [self addChip:1];
        [self removeChipNumberView];
        [self addChipNumberView];
    }
}

- (void)addChip:(int)number{
    
    chip += number;
    if(chip > 5)
        chip = 5;
    [ud setObject:[NSNumber numberWithInt:chip] forKey:@"Chip"];
    
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    [query whereKey:@"name" equalTo:self.playerName];
    NCMBObject *n;
    NSError *error;
    n = [query getFirstObject:&error];
    if(error != nil) {
        NSString *title = NSLocalizedString(@"error", @"");
        NSString *message = NSLocalizedString(@"Couldn't record your chip", @"");
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                return;
            }];
        okAction.enabled = YES;
        [alertController addAction:okAction];
        [self presentViewController:alertController
                               animated:NO
                             completion:nil];
            
            
    }
    
    [n setObject:[NSNumber numberWithInt:chip] forKey:@"chip"];
    [n saveEventually:^(NSError *error){
        if (!error){
            
        } else {
            NSString *title = NSLocalizedString(@"error", @"");
            NSString *message = NSLocalizedString(@"Couldn't record your chip", @"");
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                return;
            }];
            okAction.enabled = YES;
            
            [alertController addAction:okAction];
            [self presentViewController:alertController
                               animated:NO
                             completion:^{
                             }];

        }
    }];
    
    
    
    
    if(chip < defaultChipCount){
        if(needOfSetup){
            [self.timer invalidate];
            self.count = 60 * 15;
            [ud setObject:[NSDate date] forKey:@"BeginingTime"];
            [self.countDownFrame removeFromSuperview];
            [self startTimer:self.count];
        }
    }else{
        [self.countDownFrame removeFromSuperview];
        [self.chipAdBtn removeFromSuperview];
        [ud setObject:@(NO) forKey:@"Count"];
        [self.timer invalidate];
    }
    [ud synchronize];
}



- (void)showCount:(int)min sec:(int)sec{
    
    int m = min;
    int s = sec;
    NSMutableArray *secViewMutableArray = [NSMutableArray array];
    NSMutableArray *minViewMutableArray = [NSMutableArray array];
    for(int i = 0; i < 2; i++){
        int n = m % 10;
        UIImageView *previousView = (UIImageView *)minViewArray[i];
        [previousView removeFromSuperview];
        
        UIImageView *numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d_Count", n]]];
        if(n == 1){
            CGSize numberSize = CGSizeMake(self.countDownFrame.frame.size.width * countNumber1SizeScaleToFrame.width, self.countDownFrame.frame.size.height * countNumber1SizeScaleToFrame.height);
            numberView.frame = CGRectMake(self.countDownFrame.frame.size.width * (countMinuteXScaleToFrame[i] + 0.0047), self.countDownFrame.frame.size.height / 2.0 - numberSize.height / 2.0, numberSize.width, numberSize.height);
        }else {
            CGSize numberSize = CGSizeMake(self.countDownFrame.frame.size.width * countNumberSizeScaleToFrame.width, self.countDownFrame.frame.size.height * countNumberSizeScaleToFrame.height);
            numberView.frame = CGRectMake(self.countDownFrame.frame.size.width * countMinuteXScaleToFrame[i], self.countDownFrame.frame.size.height / 2.0 - numberSize.height / 2.0, numberSize.width, numberSize.height);
        }
        [minViewMutableArray addObject:numberView];
        [self.countDownFrame addSubview:numberView];
        m /= 10;
    }
    
    for(int i = 0; i < 2; i++){
        int n = s % 10;
        UIImageView *previousView = (UIImageView *)secViewArray[i];
        [previousView removeFromSuperview];
        UIImageView *numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d_Count", n]]];
        if(n == 1){
            CGSize numberSize = CGSizeMake(self.countDownFrame.frame.size.width * countNumber1SizeScaleToFrame.width, self.countDownFrame.frame.size.height * countNumber1SizeScaleToFrame.height);
            numberView.frame = CGRectMake(self.countDownFrame.frame.size.width * (countSecondXScaleToFrame[i] + 0.0047), self.countDownFrame.frame.size.height / 2.0 - numberSize.height / 2.0, numberSize.width, numberSize.height);
        }else {
            CGSize numberSize = CGSizeMake(self.countDownFrame.frame.size.width * countNumberSizeScaleToFrame.width, self.countDownFrame.frame.size.height * countNumberSizeScaleToFrame.height);
            numberView.frame = CGRectMake(self.countDownFrame.frame.size.width * countSecondXScaleToFrame[i], self.countDownFrame.frame.size.height / 2.0 - numberSize.height / 2.0, numberSize.width, numberSize.height);
        }
        [secViewMutableArray addObject:numberView];
        [self.countDownFrame addSubview:numberView];
        s /= 10;
    }
    minViewArray = [[NSArray alloc] initWithArray:minViewMutableArray];
    secViewArray = [[NSArray alloc] initWithArray:secViewMutableArray];
    
}


- (void)configureRewardedAd{
    [[GADRewardBasedVideoAd sharedInstance] setDelegate:self];
    [self loadRewardAd];
    [self configureRewardedAdViews];
}

- (void)loadRewardAd{
    if(![[GADRewardBasedVideoAd sharedInstance] isReady]){
        GADRequest *request = [GADRequest request];
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:@"ca-app-pub-8719818866106636/1398744103"];
    }
}



- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSString* kResumeAdBtnImage = @"ResumeAdBtn";
    NSString *btn = NSLocalizedString(kResumeAdBtnImage, @"");
    self.resumeAdBtn.userInteractionEnabled = YES;
    [self.resumeAdBtn setImage:[UIImage imageNamed:btn] forState:UIControlStateNormal];
}

- (void)configureRewardedAdViews{
    float adCancelBtnSizeScale = 0.25;
    float adExplanationSizeScaleToWidth = 0.4166;
    sizeScale adExplanationBtnSizeScaleToAdView = {0.7173, 0.145};
    float adExplanationBtnYScaleToAdView = 0.8297;
    NSString* kChipBtnImage = @"ChipBtn";
    NSString* kCancelBtnImage = @"CancelBtnOfTitleAdView";
    NSString* kAdExplanationImage = @"AdExplanation";
    NSString *image = NSLocalizedString(kAdExplanationImage, @"");
    NSString* kLoadingAd = @"LoadingAd";
    NSString *btn = NSLocalizedString(kLoadingAd, @"");
    
    [self configureAdCount];
    if(self.chipAdBtn == nil){
        float chipBtnSize = referenceSize.width * squareBtnSizeScale;
        self.chipAdBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width - chipBtnSize - (referenceSize.width * intervalScaleOfSquareBtnToWidth), referenceSize.height - chipBtnSize - (referenceSize.height * intervalScaleOfSquareBtnToWidth), chipBtnSize, chipBtnSize)];
        [self.chipAdBtn setImage:[UIImage imageNamed:kChipBtnImage] forState:UIControlStateNormal];
        [self.chipAdBtn addTarget:self action:@selector(showAdExplanation) forControlEvents:UIControlEventTouchUpInside];
    }
    
    float adExplanationViewSize = referenceSize.width * adExplanationSizeScaleToWidth;
    self.adExplanationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    self.adExplanationView.frame = CGRectMake(referenceSize.width / 2.0 - adExplanationViewSize / 2.0, referenceSize.height / 2.0 - adExplanationViewSize / 2.0, adExplanationViewSize, adExplanationViewSize);
    self.adExplanationView.layer.zPosition = 1.5;
    self.adExplanationView.userInteractionEnabled = YES;
    
    CGSize explanationbtnSize = CGSizeMake(adExplanationViewSize * adExplanationBtnSizeScaleToAdView.width, adExplanationViewSize * adExplanationBtnSizeScaleToAdView.height);
    self.resumeAdBtn = [[UIButton alloc] initWithFrame:CGRectMake(adExplanationViewSize / 2.0 - explanationbtnSize.width / 2.0, adExplanationViewSize * adExplanationBtnYScaleToAdView, explanationbtnSize.width, explanationbtnSize.height)];
    [self.resumeAdBtn setImage:[UIImage imageNamed:btn] forState:UIControlStateNormal];
    [self.resumeAdBtn addTarget:self action:@selector(playAd) forControlEvents:UIControlEventTouchUpInside];
    
    float adCancelBtnSize = self.adExplanationView.frame.size.height * adCancelBtnSizeScale;
    self.adCancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.adExplanationView.frame.size.width - adCancelBtnSize / 1.8, 0 - adCancelBtnSize / 3.0, adCancelBtnSize, adCancelBtnSize)];
    [self.adCancelbtn setImage:[UIImage imageNamed:kCancelBtnImage] forState:UIControlStateNormal];
    [self.adCancelbtn addTarget:self action:@selector(backHomeFromAd) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configureAdCount{
    ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"AdCount"] == nil){
        adCount = 3;
        [ud setObject:@(3) forKey:@"AdCount"];
        [ud synchronize];
    } else{
        adCount = [[ud objectForKey:@"AdCount"] intValue];
    }
}

- (void)playAd{
    if([[GADRewardBasedVideoAd sharedInstance] isReady])
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    else{
        [self loadRewardAd];
    }
}

- (void)backHomeFromAd{
    [self.delegate touchBtnSound2];
    self.playBtn.userInteractionEnabled = YES;
    self.howToPlayBtn.userInteractionEnabled = YES;
    self.rankBtn.userInteractionEnabled = YES;
    self.soundBtn.userInteractionEnabled = YES;
    self.chipAdBtn.userInteractionEnabled = YES;
    self.showingAdExplanation = NO;
    showingAdExView = NO;
    [self.blackCover removeFromSuperview];
    [self.adExplanationView removeFromSuperview];
    
    if(gotChipByAd && chip < defaultChipCount){
        [self configureRewardedAdViews];
        [self loadRewardAd];
        gotChipByAd = NO;
    }
}

- (void)showAdExplanation{
    [self.delegate touchBtnSound];
    self.playBtn.userInteractionEnabled = NO;
    self.howToPlayBtn.userInteractionEnabled = NO;
    self.rankBtn.userInteractionEnabled = NO;
    self.soundBtn.userInteractionEnabled = NO;
    self.chipAdBtn.userInteractionEnabled = NO;
    self.showingAdExplanation = YES;
    showingAdExView = YES;
    [self.view addSubview:self.blackCover];
    [self.view addSubview:self.adExplanationView];
    [self.adExplanationView addSubview:self.resumeAdBtn];
    [self.adCountNumberView removeFromSuperview];
    [self drawAdCountNumberView:adCount];
    [self.adExplanationView addSubview:self.adCountNumberView];
    [self.adExplanationView addSubview:self.adCancelbtn];
}





- (void)timerOff{
    if([self.timer isValid]){
        [self.timer invalidate];
    }
}



- (void)showBanner{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/4319727709";
    }else{
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/5008471306";
        
    }
    
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:request];
    
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    needOfSetup = NO;
}

- (void)enterFromBackground{
    [self canAddChip];
}

- (void)enterBackground{
    needOfSetup = NO;
    [self timerOff];
}




- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *languageID = [languages objectAtIndex:0];
    adCount--;
    [self.adCountNumberView removeFromSuperview];
    if(adCount == 1 && ![languageID isEqualToString:@"ja-JP"]){
        
        [self.adExplanationView setImage:[UIImage imageNamed:@"AdExplanationEnglish2"]];
        [self drawAdCountNumberView:adCount];
        [self.adExplanationView addSubview:self.adCountNumberView];
        ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@(adCount) forKey:@"AdCount"];
    } else if(adCount == 0){
        NSString* kgotTheChipImage = @"GotTheChipExplanation";
        NSString *image = NSLocalizedString(kgotTheChipImage, @"");
        NSString* kCloseAdBtnImage = @"CloseAdExplanationBtn";
        NSString *btn = NSLocalizedString(kCloseAdBtnImage, @"");
        
        [self addChip:1];
        [self removeChipNumberView];
        [self addChipNumberView];
        adCount = 3;
        [ud setObject:@(adCount) forKey:@"AdCount"];
        [self.resumeAdBtn removeFromSuperview];
        self.resumeAdBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.resumeAdBtn.frame.origin.x, self.resumeAdBtn.frame.origin.y, self.resumeAdBtn.frame.size.width, self.resumeAdBtn.frame.size.height)];
        self.adExplanationView.image = [UIImage imageNamed:image];
        [self.resumeAdBtn setImage:[UIImage imageNamed:btn] forState:UIControlStateNormal];
        [self.resumeAdBtn addTarget:self action:@selector(backHomeFromAd) forControlEvents:UIControlEventTouchUpInside];
        [self.adExplanationView addSubview:self.resumeAdBtn];
        gotChipByAd = YES;
        self.resumeAdBtn.userInteractionEnabled = YES;
    }else{
        [self drawAdCountNumberView:adCount];
        [self.adExplanationView addSubview:self.adCountNumberView];
        ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@(adCount) forKey:@"AdCount"];
    }

}

- (void)drawAdCountNumberView:(int)adCount{
    static sizeScale adCountNumberSizeScale = {0.04021, 0.05978};
    static sizeScale adCountNumber1SizeScale = {0.02934, 0.05978};
    static float adCountNumberXScale = 0.51298;
    static float adCountNumberYScale = 0.738568;
    
    
    if(adCount == 1){
        self.adCountNumberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.adExplanationView.frame.size.width * (adCountNumberXScale + 0.005435), self.adExplanationView.frame.size.height * adCountNumberYScale, self.adExplanationView.frame.size.width * adCountNumber1SizeScale.width, self.adExplanationView.frame.size.height * adCountNumber1SizeScale.height)];
    }else{
        self.adCountNumberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.adExplanationView.frame.size.width * adCountNumberXScale, self.adExplanationView.frame.size.height * adCountNumberYScale, self.adExplanationView.frame.size.width * adCountNumberSizeScale.width, self.adExplanationView.frame.size.height * adCountNumberSizeScale.height)];
    }
    self.adCountNumberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"CountNumberOfAd%d", adCount]];
}



- (void)setNeedOfSetup:(BOOL)Yes{
    needOfSetup = Yes;
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    if(adCount < 3)
        [self loadRewardAd];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    NSString* kLoadingAd = @"LoadingAd";
    NSString *btn = NSLocalizedString(kLoadingAd, @"");
    
    needOfSetup = NO;
    self.resumeAdBtn.userInteractionEnabled = NO;
    [self.resumeAdBtn setImage:[UIImage imageNamed:btn] forState:UIControlStateNormal];
}


- (void)setChip:(int)newChip{
    chip = newChip;
    
}

- (int)getChip{
    return chip;
}

- (void)removeChipNumberView{
    for(UIImageView *n in self.currentChipViews){
        [n removeFromSuperview];
    }
}

- (void)addChipNumberView{
    float numberYScale = 0.139;
    sizeScale number1SizeScale = {0.026, 0.09};
    sizeScale numberSizeScale = {0.037, 0.09};
    float chipXScale[5] = {0.93, 0.89, 0.85, 0.81, 0.77};
    
    int j = 0;
    int n = chip;
    NSMutableArray *tempCurrentChipViews = [NSMutableArray array];
    do{
        int i = n % 10;
        UIImageView *numberView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d_TitleView", i]]];
        if(i == 1)
            numberView.frame = CGRectMake(referenceSize.width * (chipXScale[j] + 0.0055), referenceSize.height * numberYScale, referenceSize.width * number1SizeScale.width, referenceSize.height * number1SizeScale.height);
        else
            numberView.frame = CGRectMake(referenceSize.width * chipXScale[j], referenceSize.height * numberYScale, referenceSize.width * numberSizeScale.width, referenceSize.height * numberSizeScale.height);
        [tempCurrentChipViews addObject:numberView];
        [self.view addSubview:numberView];
        j += 1;
        n /= 10;
    }while(n >= 1);
    self.currentChipViews = [[NSArray alloc] initWithArray:tempCurrentChipViews];

}


- (void)dealloc{
    NSLog(@"ViewController B instance was released.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    // Dispose of any resources that can be recreated.
}

@end
