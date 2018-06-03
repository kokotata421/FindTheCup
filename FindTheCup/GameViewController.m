//
//  GameViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/30.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "GameViewController.h"
#import "ViewController.h"


@interface GameViewController (){
    BOOL ballPositionOccupation[5];
    BOOL ballColorOccupation[5];
    BOOL cupPositionOccupation[5];
    CupView *shuffleCup1;
    CupView *shuffleCup2;
    int times;
    int correctAnswer;
    int answer;
    UIImageView *question;
    NSArray *paysOffViewArray;
    NSArray *betViewArray;
    int confirmPosition;
    BOOL result;
    NSTimer* tm;
    int countDown;
    NSArray *countDownImages;
    UIImageView *countDownImageView;
    
}

@end


@implementation GameViewController




static NSString* kGameViewImage = @"GameView";
static NSString* kGameViewImageDuringQuestion = @"GameViewDuringQuestion";
static NSString* kRingImage = @"Ring";
static NSString* kTapToStartImage = @"TapToStart";


static NSString* kNumberOnBoard_0Image = @"NumberOnBoard_0";
static NSString* kNumberOnBoard_1Image = @"NumberOnBoard_1";
static NSString* kNumberOnBoard_2Image = @"NumberOnBoard_2";
static NSString* kNumberOnBoard_3Image = @"NumberOnBoard_3";
static NSString* kNumberOnBoard_4Image = @"NumberOnBoard_4";
static NSString* kNumberOnBoard_5Image = @"NumberOnBoard_5";
static NSString* kNumberOnBoard_6Image = @"NumberOnBoard_6";
static NSString* kNumberOnBoard_7Image = @"NumberOnBoard_7";
static NSString* kNumberOnBoard_8Image = @"NumberOnBoard_8";
static NSString* kNumberOnBoard_9Image = @"NumberOnBoard_9";
static NSString* kWhereIsRedBallImage = @"WhereIsRedBall?";
static NSString* kWhereIsBlueBallImage = @"WhereIsBlueBall?";
static NSString* kWhereIsGreenBallImage = @"WhereIsGreenBall?";
static NSString* kWhereIsOrangeBallImage = @"WhereIsOrangeBall?";
static NSString* kWhereIsYellowBallImage = @"WhereIsYellowBall?";
static NSString* kCountDownNumber_0 = @"CountDownNumber_0";
static NSString* kCountDownNumber_1 = @"CountDownNumber_1";
static NSString* kCountDownNumber_2 = @"CountDownNumber_2";
static NSString* kCountDownNumber_3 = @"CountDownNumber_3";
static NSString* kCountDownNumber_4 = @"CountDownNumber_4";
static NSString* kCountDownNumber_5 = @"CountDownNumber_5";



static float tapToStartYScale = 0.45;
static float tapToStartHeightScale = 0.2133;
static float ringYScale = 0.675;
static float ringWidthScale = 0.1774;
static float ringHeightScale = 0.1317;
static float ringXScale1[3] = {0.1296, 0.4112, 0.6929};
static float ringXScale2[4] = {0.0278, 0.2834, 0.539, 0.7946};
static float ringXScale3[5] = {0.0042, 0.2072, 0.4112, 0.6147, 0.8183};
static float liftUpCupScale = 0.25;
static float ballSizeScale = 0.127;
static float ballYScale = 0.545;
static float cupYScale = 0.325;
static float cupWidthScale = 0.155;
static float cupHeightScale = 0.465;
static float numberWidthScale = 0.028;
static float numberWidthScale2 = 0.023;
static float numberHeightScale = 0.044;
static float numberOfBetHeightScale = 0.046;
static float numberYScale = 0.241;
static float numberXScale = 0.7446;
static float numberXScale2[2] = {0.7597, 0.7335};
static float numberOfBetYScale = 0.24115;
static float numberOfBetXScale = 0.9072;
static float numberOfBetXScale2[2] = {0.9225, 0.8972};
static float referencePositionOfRing[5];
static float questionWidthScale = 0.8378;
static float questionHeightScale = 0.1;
static float questionYScale = 0.02;
static float countNumberSizeScale = 0.0724;
static float countNumberYScale = 0.15;

static BOOL gameStarted = NO;
static BOOL fromBackGround = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.delegate = (ViewController *)self.parentViewController;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(enterFromBackground) name:@"enterFromBackground" object:nil];
    [nc addObserver:self selector:@selector(enterBackground) name:@"enterBackground" object:nil];
    fromBackGround = NO;
    [self.delegate playMainBGM];
    [self setUpPositionOccupationInfomation];
    [self setUpGameView];
    [self setRing];
    [self setCup];
    [self setBall];
    [self setTapBtn];
}

- (void)setUpPositionOccupationInfomation{
    for(int i = 0; i < self.stage.level + 3; i++){
        ballPositionOccupation[i] = NO;
        ballColorOccupation[i] = NO;
        cupPositionOccupation[i] = NO;
    }
    countDown = 5;
    times = self.stage.times;
    answer = 6;
    self.view.userInteractionEnabled = YES;
}



- (void)setUpGameView{
    NSArray *numbersOnStageBoard = [NSArray arrayWithObjects:[UIImage imageNamed:kNumberOnBoard_0Image], [UIImage imageNamed:kNumberOnBoard_1Image], [UIImage imageNamed:kNumberOnBoard_2Image], [UIImage imageNamed:kNumberOnBoard_3Image], [UIImage imageNamed:kNumberOnBoard_4Image], [UIImage imageNamed:kNumberOnBoard_5Image], [UIImage imageNamed:kNumberOnBoard_6Image], [UIImage imageNamed:kNumberOnBoard_7Image], [UIImage imageNamed:kNumberOnBoard_8Image], [UIImage imageNamed:kNumberOnBoard_9Image],nil];

    
    
    self.gameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 1.05)];
    self.gameView.image = [UIImage imageNamed:kGameViewImage];
    self.gameView.userInteractionEnabled = YES;
    [self.view addSubview:self.gameView];
    int paysOff = self.stage.paysOff;
    NSMutableArray *mutablePaysOffViewArray = [NSMutableArray array];
    if(paysOff < 10){
        UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * numberXScale, self.view.frame.size.height * numberYScale, self.view.frame.size.width * numberWidthScale, self.view.frame.size.height * numberHeightScale)];
        numberView.image = numbersOnStageBoard[paysOff];
        [mutablePaysOffViewArray addObject:numberView];
        [self.view addSubview:numberView];
    }else{
        int number = paysOff;
        for(int i = 0; i < 2; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * numberXScale2[i], self.view.frame.size.height * numberYScale, self.view.frame.size.width * numberWidthScale2, self.view.frame.size.height * numberHeightScale)];
            numberView.image = numbersOnStageBoard[number % 10];
            [mutablePaysOffViewArray addObject:numberView];
            [self.view addSubview:numberView];
            number /= 10;
        }
    }
    paysOffViewArray = [NSArray arrayWithArray:mutablePaysOffViewArray];
    
    int bet = self.stage.bet;
    NSMutableArray *mutableBetViewArray = [NSMutableArray array];
    if(bet < 10){
        UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * numberOfBetXScale, self.view.frame.size.height * numberOfBetYScale, self.view.frame.size.width * numberWidthScale, self.view.frame.size.height * numberOfBetHeightScale)];
        numberView.image = numbersOnStageBoard[bet];
        [mutableBetViewArray addObject:numberView];
        [self.view addSubview:numberView];
    }else{
        int number = bet;
        for(int i = 0; i < 2; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * numberOfBetXScale2[i], self.view.frame.size.height * numberOfBetYScale, self.view.frame.size.width * numberWidthScale2, self.view.frame.size.height * numberOfBetHeightScale)];
            numberView.image = numbersOnStageBoard[number % 10];
            [mutableBetViewArray addObject:numberView];
            [self.view addSubview:numberView];
            number /= 10;
        }
    }
    betViewArray = [NSArray arrayWithArray:mutableBetViewArray];
}

- (void)setRing{
    CGSize ringSize = CGSizeMake(self.view.frame.size.width * ringWidthScale, self.view.frame.size.height * ringHeightScale);
    switch (self.stage.level) {
        case 0:
            for(int i = 0; i < 3; i++){ UIImageView *ringView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * ringXScale1[i], self.view.frame.size.height * ringYScale, ringSize.width, ringSize.height)];
            
                ringView.image = [UIImage imageNamed:kRingImage];
                [self.view addSubview:ringView];
                referencePositionOfRing[i] = ringView.frame.origin.x + ringView.frame.size.width / 2.0;
            }break;
        case 1:
            for(int i = 0; i < 4; i++){ UIImageView *ringView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * ringXScale2[i], self.view.frame.size.height * ringYScale, ringSize.width, ringSize.height)];
                
                ringView.image = [UIImage imageNamed:kRingImage];
                [self.view addSubview:ringView];
                referencePositionOfRing[i] = ringView.frame.origin.x + ringView.frame.size.width / 2.0;
            }break;
        case 2:
            for(int i = 0; i < 5; i++){ UIImageView *ringView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * ringXScale3[i], self.view.frame.size.height * ringYScale, ringSize.width, ringSize.height)];
                
                ringView.image = [UIImage imageNamed:kRingImage];
                [self.view addSubview:ringView];
                referencePositionOfRing[i] = ringView.frame.origin.x + ringView.frame.size.width / 2.0;
            }break;
            
        default:
            break;
    }
    
}

- (void)setCup{
    for(int i = 0; i < self.stage.level + 3; i++){
        int p;
        while(1){
            p = arc4random_uniform(self.stage.level + 3);
            if(cupPositionOccupation[p] == YES)
                continue;
            cupPositionOccupation[p] = YES;
            break;
        }
        
        
        CupView *cupView = [[CupView alloc] initWithPosition:p Color:i Delegate:self];
        cupView.layer.zPosition = 2.0;
        switch (i) {
            case RED:self.redCup = cupView;
                break;
            case BLUE:self.blueCup = cupView;
                break;
            case GREEN:self.greenCup = cupView;
                break;
            case ORANGE:self.orangeCup = cupView;
                break;
            case YELLOW:self.yellowCup = cupView;
                break;
            default: break;
        }
        
        CGSize cupSize = CGSizeMake(self.view.frame.size.width * cupWidthScale, self.view.frame.size.height * cupHeightScale);
        cupView.frame = CGRectMake(referencePositionOfRing[p] - cupSize.width / 2.0, self.view.frame.size.height * cupYScale, cupSize.width, cupSize.height);
        
        [self.view addSubview:cupView];
    }
}

- (void)setBall{
    
    for(int i = 0; i < self.stage.numberOfBall; i++){
        int p;
        int c;
        while(1){
            p = arc4random_uniform(self.stage.level + 3);
            if(ballPositionOccupation[p] == YES)
                continue;
            ballPositionOccupation[p] = YES;
            break;
        }
        
        while(1){
            c = arc4random_uniform(self.stage.level + 3);
            if(ballColorOccupation[c] == YES)
                continue;
            ballColorOccupation[c] = YES;
            break;
        }
        BallView *ballView = [[BallView alloc] initWithPosition:p Color:c];
        ballView.layer.zPosition = 1.0;
        [self linkCupWithBall:ballView];
        switch (c) {
            case RED:self.redBall = ballView;
                     break;
            case BLUE:self.blueBall = ballView;
                     break;
            case GREEN:self.greenBall = ballView;
                     break;
            case ORANGE:self.orangeBall = ballView;
                     break;
            case YELLOW:self.yellowBall = ballView;
                     break;
            default: break;
        }
        
        CGSize ballSize = CGSizeMake(self.view.frame.size.width * ballSizeScale, self.view.frame.size.width * ballSizeScale);
        ballView.frame = CGRectMake(referencePositionOfRing[p] - ballSize.width / 2.0, self.view.frame.size.height * ballYScale, ballSize.width, ballSize.height);
        
        [self.view addSubview:ballView];
    }
    
}

- (void)linkCupWithBall:(BallView *)ballView{
    Cup *cup = [self getCupFromPosition:ballView.ball.position];
    cup.ball = ballView.ball;
    
}

- (Cup *)getCupFromPosition:(int)position{
    if(self.redCup.cup.position == position)
        return self.redCup.cup;
    else if(self.blueCup.cup.position == position)
        return self.blueCup.cup;
    else if(self.greenCup.cup.position == position)
        return self.greenCup.cup;
    else if(self.orangeCup.cup.position == position)
            return self.orangeCup.cup;
    else
        return self.yellowCup.cup;
}

- (CupView *)getCupViewfromColor:(color)color{

    switch (color) {
        case RED: return self.redCup;
        case BLUE: return self.blueCup;
        case GREEN: return self.greenCup;
        case ORANGE: return self.orangeCup;
        case YELLOW: return self.yellowCup;
        default:break;
    }
    return nil;
}

- (void)setTapBtn{
    CGRect tapBtnFrame = CGRectMake(0, self.view.frame.size.height * tapToStartYScale, self.view.frame.size.width, self.view.frame.size.height * tapToStartHeightScale);
    self.tapToStartBtn = [[UIButton alloc] initWithFrame:tapBtnFrame];
    [self.tapToStartBtn setImage:[UIImage imageNamed:kTapToStartImage] forState:UIControlStateNormal];
    [self.tapToStartBtn addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
    self.tapToStartBtn.userInteractionEnabled = YES;
    self.tapToStartBtn.layer.zPosition = 3.0;
    [self.view addSubview:self.tapToStartBtn];
    [self tapToStartBtnAnimation];
    
}

- (void)playGame{
    gameStarted = YES;
    [self tapToStartBtnAnimationStop];
    [self.tapToStartBtn removeFromSuperview];
    [self confirmBallPosition];
    
}

- (void)tapToStartBtnAnimation{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.tapToStartBtn.alpha = 0.7;
        self.tapToStartBtn.transform = CGAffineTransformMakeScale(1.03, 1.03);
        
    }completion:^(BOOL finished){}];
    
}


- (void)tapToStartBtnAnimationStop{
    [self.tapToStartBtn.layer removeAllAnimations];
    
}

- (void)confirmBallPosition{
    switch (self.stage.level) {
        case 0: [self confirmBallAtBeginner]; break;
        case 1: [self confirmBallAtIntermediate]; break;
        case 2: [self confirmBallAtAdvanced]; break;
            
        default:
            break;
    }
}


-(void)confirmBallAtBeginner{
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
    }completion:^(BOOL finished){ [self returnCupsAtBeginner];}];
}

- (void)returnCupsAtBeginner{
    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
    }completion:^(BOOL finished){[self shuffleCups];}];
}

-(void)confirmBallAtIntermediate{
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
        self.orangeCup.frame = CGRectMake(self.orangeCup.frame.origin.x, self.orangeCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.orangeCup.frame.size.width, self.orangeCup.frame.size.height);
    }completion:^(BOOL finished){ [self returnCupsAtIntermediate];}];
    
}

- (void)returnCupsAtIntermediate{
    
    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
        self.orangeCup.frame = CGRectMake(self.orangeCup.frame.origin.x, self.orangeCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.orangeCup.frame.size.width, self.orangeCup.frame.size.height);
    }completion:^(BOOL finished){[self shuffleCups];}];
}

-(void)confirmBallAtAdvanced{
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
        self.orangeCup.frame = CGRectMake(self.orangeCup.frame.origin.x, self.orangeCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.orangeCup.frame.size.width, self.orangeCup.frame.size.height);
        self.yellowCup.frame = CGRectMake(self.yellowCup.frame.origin.x, self.yellowCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.yellowCup.frame.size.width, self.yellowCup.frame.size.height);

    }completion:^(BOOL finished){ [self returnCupsAtAdvanced];}];
    
}

- (void)returnCupsAtAdvanced{
    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
        self.orangeCup.frame = CGRectMake(self.orangeCup.frame.origin.x, self.orangeCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.orangeCup.frame.size.width, self.orangeCup.frame.size.height);
        self.yellowCup.frame = CGRectMake(self.yellowCup.frame.origin.x, self.yellowCup.frame.origin.y + self.view.frame.size.height * liftUpCupScale, self.yellowCup.frame.size.width, self.yellowCup.frame.size.height);
            }completion:^(BOOL finished){[self shuffleCups];}];
    
}


- (void)shuffleCups{
    int n;
    int n2;
    do{
        n = arc4random_uniform(self.stage.level + 3);
        n2 = arc4random_uniform(self.stage.level + 3);
    }while(n == n2 || ((shuffleCup1.cup.color == n || shuffleCup2.cup.color == n) && (shuffleCup1.cup.color == n2 || shuffleCup2.cup.color == n2)));
    
    shuffleCup1 = [self getCupViewfromColor:n];
    shuffleCup2 = [self getCupViewfromColor:n2];

    if(times < 3){
        [self shuffleWithBallCup1:shuffleCup1 Cup2:shuffleCup2];
    }else if(arc4random_uniform(2)){
        [self shuffleWithoutBallCup1:shuffleCup1 Cup2:shuffleCup2];
    }else{
        [self shuffleWithBallCup1:shuffleCup1 Cup2:shuffleCup2];
    }
}

- (void)shuffleWithoutBallCup1:(CupView*)cup1 Cup2:(CupView*)cup2{
    __weak GameViewController* weakSelf = self;
        
    CALayer* theLayer1 = cup1.layer;
    CALayer* theLayer2 = cup2.layer;
    theLayer1.zPosition = 4.0;
    theLayer2.zPosition = 4.0;
    
    float cup1XPoint = cup1.center.x;
    float cup2XPoint = cup2.center.x;
    float cupYPoint = cup1.center.y;
    float liftHeight = self.view.frame.size.height * (liftUpCupScale + 0.5);
    
    
    CAKeyframeAnimation *cup1Animation;
    cup1Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CAKeyframeAnimation *cup2Animation;
    cup2Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    float shuffleDistance;
    shuffleDistance = cup2XPoint - cup1XPoint;
    
    CGMutablePathRef curvedPath1 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath1, NULL, cup1XPoint, cupYPoint);
    CGPathAddCurveToPoint(curvedPath1, NULL,
                          cup1XPoint, cupYPoint,
                          cup1XPoint + shuffleDistance / 2.0 , cupYPoint - liftHeight,
                          cup2XPoint, cupYPoint);
    cup1Animation.fillMode = kCAFillModeForwards;
    cup1Animation.removedOnCompletion = NO;
    cup1Animation.duration = self.stage.speed;
    cup1Animation.delegate = weakSelf;
    cup1Animation.path = curvedPath1;
    CGPathRelease(curvedPath1);
    
    shuffleDistance = cup1XPoint - cup2XPoint;
    CGMutablePathRef curvedPath2 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath2, NULL, cup2XPoint, cupYPoint);
    CGPathAddCurveToPoint(curvedPath2, NULL,
                          cup2XPoint, cupYPoint,
                          cup2XPoint + shuffleDistance / 2.0 , cupYPoint - liftHeight,
                          cup1XPoint, cupYPoint);
    cup2Animation.fillMode = kCAFillModeForwards;
    cup2Animation.removedOnCompletion = NO;
    cup2Animation.duration = self.stage.speed;
    cup2Animation.delegate = weakSelf;
    cup2Animation.path = curvedPath2;
    CGPathRelease(curvedPath2);
    [self.delegate shuffleSound];
    [theLayer1 addAnimation:cup1Animation forKey:@"ShuffleCupWitoutBall1"];
    [theLayer2 addAnimation:cup2Animation forKey:@"ShuffleCupWitoutBall2"];
    
}

- (void)shuffleWithBallCup1:(CupView*)cup1 Cup2:(CupView*)cup2{
    __weak GameViewController* weakSelf = self;
    
    BallView *ballView1;
    BallView *ballView2;
    if(cup1.cup.ball){
        ballView1 = [self getBallViewFromColor:cup1.cup.ball.color];
        [ballView1 removeFromSuperview];
    }
    
    if(cup2.cup.ball){
        ballView2 = [self getBallViewFromColor:cup2.cup.ball.color];
        [ballView2 removeFromSuperview];
    }
    
    CALayer* theLayer1 = cup1.layer;
    CALayer* theLayer2 = cup2.layer;
    theLayer1.zPosition = 4.0;
    theLayer2.zPosition = 4.0;
    
    float cup1XPoint = cup1.center.x;
    float cup2XPoint = cup2.center.x;
    float cupYPoint = cup1.center.y;
    
    CAKeyframeAnimation *cup1Animation;
    cup1Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cup1Animation.fillMode = kCAFillModeForwards;
    cup1Animation.removedOnCompletion = NO;
    cup1Animation.duration = self.stage.speed;

    
    CAKeyframeAnimation *cup2Animation;
    cup2Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cup2Animation.fillMode = kCAFillModeForwards;
    cup2Animation.removedOnCompletion = NO;
    cup2Animation.duration = self.stage.speed;

    
    float shuffleDistance;
    shuffleDistance = cup2XPoint - cup1XPoint;
    
    
    CGMutablePathRef curvedPath1 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath1, NULL, cup1XPoint, cupYPoint);
    CGPathAddCurveToPoint(curvedPath1, NULL,
                          cup1XPoint, cupYPoint,
                          cup1XPoint + shuffleDistance / 2.0 , cupYPoint + self.view.frame.size.height * 0.25,
                          cup2XPoint, cupYPoint);
    cup1Animation.delegate = weakSelf;
    cup1Animation.path = curvedPath1;
    CGPathRelease(curvedPath1);
    
    shuffleDistance = cup1XPoint - cup2XPoint;
    CGMutablePathRef curvedPath2 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath2, NULL, cup2XPoint, cupYPoint);
    CGPathAddCurveToPoint(curvedPath2, NULL,
                          cup2XPoint, cupYPoint,
                          cup2XPoint + shuffleDistance / 2.0 , cupYPoint + self.view.frame.size.height * 0.25,
                          cup1XPoint, cupYPoint);
    cup2Animation.delegate = weakSelf;
    cup2Animation.path = curvedPath2;
    CGPathRelease(curvedPath2);
    
    [self.delegate shuffleSound];
    [theLayer1 addAnimation:cup1Animation forKey:@"ShuffleCupWithBall1"];
    [theLayer2 addAnimation:cup2Animation forKey:@"ShuffleCupWithBall2"];
    
}

- (void)animationDidStart:(CAAnimation *)anim{
    shuffleCup1.transform = CGAffineTransformMakeScale(1.03, 1.03);
    shuffleCup2.transform = CGAffineTransformMakeScale(1.03, 1.03);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(anim == [shuffleCup1.layer animationForKey:@"ShuffleCupWithBall1"] || anim == [shuffleCup1.layer animationForKey:@"ShuffleCupWitoutBall1"]){
        times--;
        shuffleCup1.transform = CGAffineTransformIdentity;
        shuffleCup2.transform = CGAffineTransformIdentity;
        shuffleCup1.layer.zPosition = 2.0;
        shuffleCup2.layer.zPosition = 2.0;
        CGRect tempFrame = shuffleCup1.frame;
        shuffleCup1.frame = shuffleCup2.frame;
        shuffleCup2.frame = tempFrame;
        int tempPosition = shuffleCup1.cup.position;
        shuffleCup1.cup.position = shuffleCup2.cup.position;
        shuffleCup2.cup.position = tempPosition;
        if(anim == [shuffleCup1.layer animationForKey:@"ShuffleCupWitoutBall1"]){
            Ball* tempBall = shuffleCup1.cup.ball;
            shuffleCup1.cup.ball = shuffleCup2.cup.ball;
            shuffleCup2.cup.ball = tempBall;
        }
        if(anim == [shuffleCup1.layer animationForKey:@"ShuffleCupWithBall1"]){
            BallView *ballView1;
            BallView *ballView2;
            if(shuffleCup1.cup.ball){
                ballView1 = [self getBallViewFromColor:shuffleCup1.cup.ball.color];
                ballView1.ball.position = shuffleCup1.cup.position;
                CGRect ballFrame = [self getBallRectFromPosition:shuffleCup1.cup.position];
                ballView1.frame = ballFrame;
                [self.view addSubview:ballView1];
            }
            
            if(shuffleCup2.cup.ball){
                ballView2 = [self getBallViewFromColor:shuffleCup2.cup.ball.color];
                ballView2.ball.position = shuffleCup2.cup.position;
                CGRect ballFrame = [self getBallRectFromPosition:shuffleCup2.cup.position];
                ballView2.frame = ballFrame;
                [self.view addSubview:ballView2];
            }
           
        }
        if(times > 0){
            [self performSelector:@selector(shuffleCups) withObject:nil afterDelay:self.stage.interval];
        }else {
            [self.redCup.layer removeAllAnimations];
            [self.blueCup.layer removeAllAnimations];
            [self.greenCup.layer removeAllAnimations];
            [self.orangeCup.layer removeAllAnimations];
            [self.yellowCup.layer removeAllAnimations];
            shuffleCup1 = nil;
            shuffleCup2 = nil;
            [self performSelector:@selector(askQuestion) withObject:nil afterDelay:1.0f];
        }
    }
}


- (void)askQuestion{
    self.gameView.image = [UIImage imageNamed:kGameViewImageDuringQuestion];
    for(int i = 0; i < paysOffViewArray.count; i++){
        UIImageView * numberView = paysOffViewArray[i];
        [numberView removeFromSuperview];
    }
    
    for(int i = 0; i < betViewArray.count; i++){
        UIImageView * numberView = betViewArray[i];
        [numberView removeFromSuperview];
    }
    
    
    [self askBallPosition];
    
}

- (void)askBallPosition{
    int c;
    do {
        c = arc4random_uniform(self.stage.level + 3);
    }while([self getBallViewFromColor:c] == nil);
    
    switch (c) {
        case RED:question = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kWhereIsRedBallImage]];
                 correctAnswer = self.redBall.ball.position; break;
        case BLUE:question = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kWhereIsBlueBallImage]];
                  correctAnswer = self.blueBall.ball.position; break;
        case GREEN:question = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kWhereIsGreenBallImage]];
                   correctAnswer = self.greenBall.ball.position; break;
        case ORANGE:question = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kWhereIsOrangeBallImage]];
                    correctAnswer = self.orangeBall.ball.position; break;
        case YELLOW:question = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kWhereIsYellowBallImage]];
            correctAnswer = self.yellowBall.ball.position; break;
        default: break;
    }
    CGSize questionSize = CGSizeMake(self.view.frame.size.width * questionWidthScale, self.view.frame.size.height * questionHeightScale);
    question.frame = CGRectMake(self.view.frame.size.width / 2.0 - questionSize.width / 2.0, self.view.frame.size.height * questionYScale, questionSize.width, questionSize.height);
    question.layer.zPosition = 5.0;
    [self enableTouchOnCup];
    [self.view addSubview:question];
    countDownImages = [NSArray arrayWithObjects:[UIImage imageNamed:kCountDownNumber_0],[UIImage imageNamed:kCountDownNumber_1], [UIImage imageNamed:kCountDownNumber_2], [UIImage imageNamed:kCountDownNumber_3], [UIImage imageNamed:kCountDownNumber_4], [UIImage imageNamed:kCountDownNumber_5],nil];
    if(!fromBackGround){
        tm = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(answerCountDown) userInfo:nil repeats:YES];
    }
}



- (BallView*)getBallViewFromColor:(color)color{
    switch (color) {
        case RED: return self.redBall;
        case BLUE: return self.blueBall;
        case GREEN: return self.greenBall;
        case ORANGE: return self.orangeBall;
        case YELLOW: return self.yellowBall;
        default: break;
    }
    
    return nil;
}

- (void)enableTouchOnCup{
    self.redCup.userInteractionEnabled = YES;
    self.blueCup.userInteractionEnabled = YES;
    self.greenCup.userInteractionEnabled = YES;
    self.orangeCup.userInteractionEnabled = YES;
    self.yellowCup.userInteractionEnabled = YES;
}

- (void)disenableTouchOnCup{
    self.redCup.userInteractionEnabled = NO;
    self.blueCup.userInteractionEnabled = NO;
    self.greenCup.userInteractionEnabled = NO;
    self.orangeCup.userInteractionEnabled = NO;
    self.yellowCup.userInteractionEnabled = NO;
}

- (CGRect)getBallRectFromPosition:(int)position{
    return CGRectMake(referencePositionOfRing[position] - self.view.frame.size.width * ballSizeScale / 2.0, self.view.frame.size.height * ballYScale, self.view.frame.size.width * ballSizeScale, self.view.frame.size.width * ballSizeScale);
    
}

- (void)selectCup:(Cup *)cup{
    [countDownImageView removeFromSuperview];
    answer = cup.position;
    confirmPosition = cup.position;
    [self disenableTouchOnCup];
    self.gameView.image = [UIImage imageNamed:kGameViewImage];
    [question removeFromSuperview];
    [self.delegate selectCupSound];
    for(int i = 0; i < paysOffViewArray.count; i++){
        UIImageView *paysOffView = paysOffViewArray[i];
        [self.view addSubview:paysOffView];
    }
    
    for(int i = 0; i < betViewArray.count; i++){
        UIImageView *betView = betViewArray[i];
        [self.view addSubview:betView];
    }
    if([tm isValid])
        [tm invalidate];
    [self confirmSelectedCup];
    
}




- (void)confirmSelectedCup{
    __weak GameViewController* weakSelf = self;
    CupView *confirmCup;
    if(self.redCup.cup.position == confirmPosition)
        confirmCup = self.redCup;
    else if(self.blueCup.cup.position == confirmPosition)
        confirmCup = self.blueCup;
    else if(self.greenCup.cup.position == confirmPosition)
        confirmCup = self.greenCup;
    else if(self.orangeCup.cup.position == confirmPosition)
        confirmCup = self.orangeCup;
    else
        confirmCup = self.yellowCup;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        confirmCup.frame = CGRectMake(confirmCup.frame.origin.x, confirmCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, confirmCup.frame.size.width, confirmCup.frame.size.height);
        
    }completion:^(BOOL finished){
        if(finished)

            [weakSelf confirmWholeCups:confirmCup];
        
    }];
    
}

- (void)confirmWholeCups:(CupView *)confirmedCup{
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        if(self.redCup != confirmedCup)
            self.redCup.frame = CGRectMake(self.redCup.frame.origin.x, self.redCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.redCup.frame.size.width, self.redCup.frame.size.height);
        if(self.blueCup != confirmedCup)
            self.blueCup.frame = CGRectMake(self.blueCup.frame.origin.x, self.blueCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.blueCup.frame.size.width, self.blueCup.frame.size.height);
        if(self.greenCup != confirmedCup)
            self.greenCup.frame = CGRectMake(self.greenCup.frame.origin.x, self.greenCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.greenCup.frame.size.width, self.greenCup.frame.size.height);
        if(self.orangeCup != confirmedCup)
            self.orangeCup.frame = CGRectMake(self.orangeCup.frame.origin.x, self.orangeCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.orangeCup.frame.size.width, self.orangeCup.frame.size.height);
        if(self.yellowCup != confirmedCup)
            self.yellowCup.frame = CGRectMake(self.yellowCup.frame.origin.x, self.yellowCup.frame.origin.y - self.view.frame.size.height * liftUpCupScale, self.yellowCup.frame.size.width, self.yellowCup.frame.size.height);
    }completion:^(BOOL finished){
        result = [self checkAnswer];
        
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:1.0];
    }];
}

- (BOOL)checkAnswer{
    return (correctAnswer == answer)? YES : NO;
}

- (void)gameOver{
    self.redCup = nil;
    self.blueCup = nil;
    self.greenCup = nil;
    self.yellowCup = nil;
    self.orangeCup = nil;
    self.redBall = nil;
    self.blueBall = nil;
    self.greenBall = nil;
    self.yellowBall = nil;
    self.orangeBall = nil;
    [self.delegate moveViewControllerFromGameViewToGameOverViewWithLevel:self.stage.level Stage:self.stage.numberOfStage Result:result];
}

- (void)enterFromBackground{
    if(gameStarted){
        result = NO;
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:0.1f];
    } else{
        [self.tapToStartBtn removeFromSuperview];
        [self setTapBtn];
    }
}

- (void)enterBackground{
    if(gameStarted){
        fromBackGround = YES;
    }
}

- (void)answerCountDown{
    __weak GameViewController* weakSelf = self;
    [countDownImageView removeFromSuperview];
    if(countDown >= 0){
        CGSize countDownViewSize = CGSizeMake(self.view.frame.size.width * countNumberSizeScale, self.view.frame.size.width * countNumberSizeScale);
        if(countDown > 0)
            [self.delegate countDownSound];
        else
            [self.delegate timeUpSound];
        countDownImageView = [[UIImageView alloc] initWithImage:countDownImages[countDown--]];
        countDownImageView.frame = CGRectMake(self.view.frame.size.width / 2.0 - countDownViewSize.width / 2.0, self.view.frame.size.height * countNumberYScale, countDownViewSize.width, countDownViewSize.height);
        [self.view addSubview:countDownImageView];
           
        if(countDown == -1){
            if([tm isValid])
                [tm invalidate];
            answer = 5;
            [self disenableTouchOnCup];
            
            self.gameView.image = [UIImage imageNamed:kGameViewImage];
            [question removeFromSuperview];
            for(int i = 0; i < paysOffViewArray.count; i++){
                UIImageView *bonusView = paysOffViewArray[i];
                [self.view addSubview:bonusView];
            }
            for(int i = 0; i < betViewArray.count; i++){
                UIImageView *betView = betViewArray[i];
                [self.view addSubview:betView];
            }
            [countDownImageView removeFromSuperview];
            countDownImages = nil;
            [weakSelf performSelector:@selector(confirmWholeCups:) withObject:nil afterDelay:1.0];
        }
    }
    
}


- (BOOL)getResult{
    return result;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"ViewController B instance was released.");
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
