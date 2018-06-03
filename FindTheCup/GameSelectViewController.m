//
//  GameSelectViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/25.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "GameSelectViewController.h"
#import "ViewController.h"



typedef enum level{ BEGINNER, INTERMEDIATE, ADVANCED} level;


@interface GameSelectViewController (){
    NSUserDefaults* ud;
    UIImageView *levelView;
    UIButton *beginnerBtn;
    UIButton *intermediateBtn;
    UIButton *advancedBtn;
    UIButton *homeBtn;
    UIImageView *selectedLevelView;
    NSArray *levelStrings;
    
    NSArray *selectedLevelStageRecord;
    int accessibleStage;
    int pageNumber;
    int selectedLevel;
    NSArray* stageBtns;
    
    UIButton *nextArrow;
    UIButton *backArrow;

    UIButton *infoBtn;
    UIView *background;
    UIImageView *explanationView;
    UIButton *cancelBtn;
}



@end



@implementation GameSelectViewController





static NSString* kBeginnerImage = @"Beginner";
static NSString* kIntermediateImage = @"Intermediate";
static NSString* kAdvancedImage = @"Advanced";
static NSString* kNextArrowImage = @"NextArrow";
static NSString* kBackArrowImage = @"BackArrow";


static sizeScale eachLevelSizeScale = {0.589, 0.22};
static float arrowWidthScale = 0.12;
static float arrowHeigthtScale = 0.7407;
static float arrowYScale = 0.2592;

static int chip;

static BOOL viewSetupDone = NO;

static CGSize referenceSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    levelStrings = [[NSArray alloc] initWithObjects: @"BEGINNER", @"INTERMEDIATE", @"ADVANCED", nil];
    [self setUpGameLevelSelectView];
}

- (void)viewDidAppear:(BOOL)animated{
    self.delegate = (ViewController *)self.parentViewController;
    [self adLoad];
    [self.delegate playMainBGM];
    if(!viewSetupDone){
       [self setLevelViews];
    }else{
        viewSetupDone = NO;
    }
   // [self showBanner];
    [self performSelector:@selector(showInterstitial) withObject:nil afterDelay:0.5f];
}


- (void)adLoad{
    __weak GameSelectViewController* weakSelf = self;
    GADRequest *request = [GADRequest request];

    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-8719818866106636/3600284503"];
    self.interstitial.delegate = weakSelf;
    [self.interstitial loadRequest:request];
}

- (void)showInterstitial{
    __weak GameSelectViewController* weakSelf = self;
    if(arc4random_uniform(4) == 0 && [self.interstitial isReady]){
        [self.interstitial presentFromRootViewController:weakSelf];
        
    }
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    viewSetupDone = YES;
    [self adLoad];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView{
    viewSetupDone = YES;
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    viewSetupDone = YES;
}



- (void)setUpGameLevelSelectView{
    NSString* kGameLevelSelectView = @"GameLevelSelectView";
    NSString* kHomeBtnImage = @"HomeBtn";
    
    scale homeBtnScale = {0.001, 0.005, 0.15, 0.15};
    
    self.gameLevelSelectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGameLevelSelectView]];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.gameLevelSelectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
    else
        self.gameLevelSelectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90.0);
    [self.view addSubview:self.gameLevelSelectView];
    self.gameLevelSelectView.userInteractionEnabled = YES;
    referenceSize = self.gameLevelSelectView.frame.size;

    
    homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width * homeBtnScale.x, referenceSize.height * homeBtnScale.y, referenceSize.width * homeBtnScale.width, referenceSize.width * homeBtnScale.height)];
    [homeBtn setImage:[UIImage imageNamed:kHomeBtnImage] forState:UIControlStateNormal];
    homeBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [homeBtn addTarget:self.delegate action:@selector(moveViewControllerFromGameSelectViewToTitleView) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.userInteractionEnabled = YES;
    [self.view addSubview:homeBtn];
}

- (void)setLevelViews{
    NSString* kLevelImage = @"Level";
    sizeScale levelSizeScale = {0.56, 0.318};
    
    float length = 0.01;
    levelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLevelImage]];
    CGSize levelViewSize = CGSizeMake(referenceSize.width * levelSizeScale.width, referenceSize.height * levelSizeScale.height);
    levelView.frame = CGRectMake(referenceSize.width / 2.0 - levelViewSize.width / 2.0, referenceSize.height * length, levelViewSize.width, levelViewSize.height);
    
    [self.view addSubview:levelView];
    
    CGSize btnSize = CGSizeMake(referenceSize.width * eachLevelSizeScale.width, referenceSize.height * eachLevelSizeScale.height);
    
    beginnerBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - btnSize.width / 2.0, levelView.frame.origin.y + levelView.frame.size.height, btnSize.width, btnSize.height)];
    [beginnerBtn setImage:[UIImage imageNamed:kBeginnerImage] forState:UIControlStateNormal];
    beginnerBtn.userInteractionEnabled = YES;
    [beginnerBtn addTarget:self action:@selector(selectBeginner) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:beginnerBtn];
    
    intermediateBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - btnSize.width / 2.0, beginnerBtn.frame.origin.y + beginnerBtn.frame.size.height, btnSize.width, btnSize.height)];
    [intermediateBtn setImage:[UIImage imageNamed:kIntermediateImage] forState:UIControlStateNormal];
    intermediateBtn.userInteractionEnabled = YES;
    [intermediateBtn addTarget:self action:@selector(selectIntermediate) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:intermediateBtn];
    
    advancedBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - btnSize.width / 2.0, intermediateBtn.frame.origin.y + intermediateBtn.frame.size.height, btnSize.width, btnSize.height)];
    [advancedBtn setImage:[UIImage imageNamed:kAdvancedImage] forState:UIControlStateNormal];
    advancedBtn.userInteractionEnabled = YES;
    [advancedBtn addTarget:self action:@selector(selectAdvanced) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:advancedBtn];
}

- (void)removeLevelViews{
    [levelView removeFromSuperview];
    [beginnerBtn removeFromSuperview];
    [intermediateBtn removeFromSuperview];
    [advancedBtn removeFromSuperview];
}

-(void)selectBeginner{
    selectedLevel = BEGINNER;
    [self removeLevelViews];
    [self performSelector:@selector(selectLevel) withObject:nil afterDelay:0.1];
    
}

- (void)selectIntermediate{
    selectedLevel = INTERMEDIATE;
    [self removeLevelViews];
    [self performSelector:@selector(selectLevel) withObject:nil afterDelay:0.1];
  
}

- (void)selectAdvanced{
    selectedLevel = ADVANCED;
    [self removeLevelViews];
    [self performSelector:@selector(selectLevel) withObject:nil afterDelay:0.1];
    
}

- (void)selectLevel{
    [self.delegate touchBtnSound];
    pageNumber = 1;
    switch (selectedLevel) {
        case BEGINNER: selectedLevelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBeginnerImage]]; break;
        case INTERMEDIATE: selectedLevelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kIntermediateImage]]; break;
        case ADVANCED: selectedLevelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kAdvancedImage]]; break;
        default: break;
    }
    
    CGSize selectedLevelSize = CGSizeMake(referenceSize.width * eachLevelSizeScale.width, referenceSize.height * eachLevelSizeScale.height);
    float lengthScale = 0.04;
    
    selectedLevelView.frame = CGRectMake(referenceSize.width / 2.0 - selectedLevelSize.width / 2.0, referenceSize.height * lengthScale, selectedLevelSize.width, selectedLevelSize.height);
    
    [self.view addSubview:selectedLevelView];
    
    if(![self checkSelectedLevelStageRecord:selectedLevel])
        selectedLevelStageRecord = [self setUpStageRecord:selectedLevel];
    
    [self setUpInfoBtn];
    [self checkClearStage];
    [self setStageBtns];
    [self setArrows];
    [self showInterstitial];
}

- (void)setUpInfoBtn{
    scale infoBtnScale = {0.942, 0.053, 0.03};
    
    infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoBtn.tintColor = [UIColor whiteColor];
    infoBtn.frame = CGRectMake(referenceSize.width * infoBtnScale.x,referenceSize.height * infoBtnScale.y, referenceSize.width * infoBtnScale.width, referenceSize.width * infoBtnScale.width);
    [infoBtn addTarget:self action:@selector(showExplanation) forControlEvents:UIControlEventTouchUpInside];
    infoBtn.userInteractionEnabled = YES;
    [self.view addSubview:infoBtn];
}

- (void)showExplanation{
    NSString* kExplanationImage = @"ExplanationOfStage";
    NSString* kCancelBtn = @"CancelBtn";
    
    scale explanationScale = {0.2801, 0, 0.5457, 1};
    scale cancelBtnScale = {0.04, 0.072, 0.045, 0};
    
    [self.delegate touchBtnSound2];
    infoBtn.userInteractionEnabled = NO;
    homeBtn.userInteractionEnabled = NO;
    for(int i = 0; i < 8; i++){
        StageButton * btn = stageBtns[i];
        btn.userInteractionEnabled = NO;
    }
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, referenceSize.width, referenceSize.height)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.8;
    background.userInteractionEnabled = YES;
    [self.view addSubview:background];
    
    
    NSString *image = NSLocalizedString(kExplanationImage,@"");
    explanationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    explanationView.frame = CGRectMake(referenceSize.width * explanationScale.x, referenceSize.height * explanationScale.y, referenceSize.width * explanationScale.width, referenceSize.height * explanationScale.height);
    [self.view addSubview:explanationView];
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width * cancelBtnScale.x, referenceSize.height * cancelBtnScale.y, referenceSize.width * cancelBtnScale.width, referenceSize.width * cancelBtnScale.width)];
    [cancelBtn setImage:[UIImage imageNamed:kCancelBtn] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.userInteractionEnabled = YES;
    [self.view addSubview:cancelBtn];
    
}

- (void)backView{
    [self.delegate touchBtnSound];
    infoBtn.userInteractionEnabled = YES;
    homeBtn.userInteractionEnabled = YES;
    for(int i = 0; i < 8; i++){
        StageButton * btn = stageBtns[i];
        btn.userInteractionEnabled = YES;
    }
    
    [background removeFromSuperview];
    [explanationView removeFromSuperview];
    [cancelBtn removeFromSuperview];
}

- (BOOL)checkSelectedLevelStageRecord:(level)level{
    ud = [NSUserDefaults standardUserDefaults];
    selectedLevelStageRecord = [[NSArray alloc] initWithArray:[ud objectForKey:levelStrings[level]]];
    if([selectedLevelStageRecord lastObject] != nil)
        return YES;
    else
        return NO;
}

- (id)setUpStageRecord:(level)level{
    NSArray *stageRecord = [[NSArray alloc] initWithObjects: @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO),@(NO), @(NO) ,@(NO), @(NO), @(NO) ,@(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO), nil];
    ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:stageRecord forKey:levelStrings[level]];
    [ud synchronize];
    return stageRecord;
}

- (void)setStageBtns{
    float stageLineWidthScale = 0.65;
    
    float stageLineWidth = referenceSize.width * stageLineWidthScale;
    
    float horizontalLengthScale = 0.015;
    float verticalLengthScale = 0.04;
    
    float horizontalIntervalLength = referenceSize.width * horizontalLengthScale;
    float stageSize = (stageLineWidth - horizontalIntervalLength * 3.0) / 4.0;
    
    
    NSMutableArray *tempStageBtns = [NSMutableArray array];
                                     
    for(int i = 0; i < 8; i++){
        [tempStageBtns addObject:[[StageButton alloc] initWithLevel:selectedLevel Stage: 8 * (pageNumber - 1) + i Clear: [selectedLevelStageRecord[8 * (pageNumber - 1) + i] boolValue]]];
    }
    stageBtns = [[NSArray alloc] initWithArray:tempStageBtns];
    
    StageButton *stageBtn1 = stageBtns[0];
    
    stageBtn1.frame = CGRectMake(referenceSize.width / 2.0 - stageLineWidth / 2.0, selectedLevelView.frame.origin.y + selectedLevelView.frame.size.height + referenceSize.height * verticalLengthScale, stageSize, stageSize);
    [stageBtn1 addTarget:self action:@selector(selectStage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stageBtn1];
    
    
    for(int i = 1; i < 4; i++){
        StageButton *stageBtn = stageBtns[i];
        StageButton *pStageBtn = stageBtns[i - 1];
        stageBtn.frame = CGRectMake(pStageBtn.frame.origin.x + pStageBtn.frame.size.width + horizontalIntervalLength, pStageBtn.frame.origin.y, stageSize, stageSize);
        [stageBtn addTarget:self action:@selector(selectStage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:stageBtn];
    }
    
    StageButton *stageBtn5 = stageBtns[4];
    
    stageBtn5.frame = CGRectMake(referenceSize.width / 2.0 - stageLineWidth / 2.0, stageBtn1.frame.origin.y + stageBtn1.frame.size.height + referenceSize.height * verticalLengthScale, stageSize, stageSize);
    
    [stageBtn5 addTarget:self action:@selector(selectStage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stageBtn5];
    
    for(int i = 5; i < 8; i++){
        StageButton *stageBtn = stageBtns[i];
        StageButton *pStageBtn = stageBtns[i - 1];
        stageBtn.frame = CGRectMake(pStageBtn.frame.origin.x + pStageBtn.frame.size.width + horizontalIntervalLength, pStageBtn.frame.origin.y, pStageBtn.frame.size.width, pStageBtn.frame.size.height);
        [stageBtn addTarget:self action:@selector(selectStage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:stageBtn];
    }
    [self setStageViews];
}

- (void)selectStage:(StageButton *)btn{
    if(btn.bet > chip){
        [self.delegate cancelSound];
        return;
    }
    level level = btn.level;
    int selectedStage = btn.stage;
    
    [self.delegate moveViewControllerFromGameSelectViewToGameViewWithLevel:level Stage:selectedStage];
    
}

- (void)checkClearStage{
    accessibleStage = 2;
    do{
        if((BOOL)[selectedLevelStageRecord[accessibleStage] boolValue] == YES)
            accessibleStage++;
        else
            return;
    }while(accessibleStage < 24);
}

- (void)setStageViews{
    for(int i = 0; i < 8; i++){
        StageButton* btn = stageBtns[i];
        if(accessibleStage >= btn.stage){
            if(btn.clear)
                [btn addClearChipView];
            [btn addNumberView];
            [btn addPaysOffNumberView];
            [btn addBetNumberView];
        }else{
            btn.userInteractionEnabled = NO;
            [btn addLockView];
        }
    }
}
- (void)setArrows{
    [nextArrow removeFromSuperview];
    [backArrow removeFromSuperview];
    switch(pageNumber){
        case 1: [self setNextArrow]; break;
        case 2: [self setBothArrows]; break;
        case 3: [self setBackArrow]; break;
        default: break;
    }
}

- (void)setBothArrows{
    [self setBackArrow];
    [self setNextArrow];
}

- (void)setNextArrow{
    if(!nextArrow){
        nextArrow = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width - referenceSize.width * arrowWidthScale, referenceSize.height * arrowYScale, referenceSize.width * arrowWidthScale, referenceSize.height * arrowHeigthtScale)];
        [nextArrow setImage:[UIImage imageNamed:kNextArrowImage] forState:UIControlStateNormal];
        [nextArrow addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:nextArrow];
}

- (void)setBackArrow{
    if(!backArrow){
        backArrow = [[UIButton alloc] initWithFrame:CGRectMake(0, referenceSize.height * arrowYScale, referenceSize.width * arrowWidthScale, referenceSize.height * arrowHeigthtScale)];
        [backArrow setImage:[UIImage imageNamed:kBackArrowImage] forState:UIControlStateNormal];
        [backArrow addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:backArrow];
}


- (void)goNext{
    [self.delegate touchBtnSound];
    pageNumber++;
    [self removeStageBtnViews];
    [self setStageBtns];
    [self setArrows];
}

- (void)goBack{
    [self.delegate touchBtnSound];
    pageNumber--;
    [self removeStageBtnViews];
    [self setStageBtns];
    [self setArrows];
}

- (void)removeStageBtnViews{
    for(int i = 0; i < 8; i++){
        StageButton* btn = stageBtns[i];
        [btn removeViews];
    }
}


- (void)showBanner{
    __weak GameSelectViewController* weakSelf = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/3600284503";
    }else{
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/3401808106";
        
    }
    
    self.bannerView.rootViewController = weakSelf;
    
    GADRequest *request = [GADRequest request];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:request];
}

- (int)setChip:(int)newChip{
    chip = newChip;
    return newChip;
}

- (int)getChip{
    return chip;
}

- (void)removeStageViews{
    [levelView removeFromSuperview];
    [beginnerBtn removeFromSuperview];
    [intermediateBtn removeFromSuperview];
    [advancedBtn removeFromSuperview];
    [selectedLevelView removeFromSuperview];
    [infoBtn removeFromSuperview];
    for(StageButton *n in stageBtns){
        [n removeFromSuperview];
    }
    [nextArrow removeFromSuperview];
    [backArrow removeFromSuperview];
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
