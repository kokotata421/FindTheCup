//
//  RankViewController.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/29.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "RankViewController.h"
#import "ViewController.h"
#import "NCMB.h"
#import "NCMBFile.h"
#import "NCMBObject.h"
#import "NCMBQuery.h"
#import "SVProgressHUD.h"
#import "RankCellView.h"


@interface RankViewController (){
    UIView *loadingView;
    NSArray *rankArray;
    int numberOfRankCell;
    NSString *name;
    NSUserDefaults *ud;
    UIImageView *rankCrownIconView;
    NCMBObject *lastObject;
}



@end

@implementation RankViewController

static NSString* kBackBtnImage = @"BackBtnOfRankView";
static NSString* rankViewImage = @"RankView";
static float segmentHeightScale = 0.10;
static float segmentWidthScale = 0.4;
static float segmentYScale = 0.03;
static float rankCrownIconWidthScale = 0.45;
static float rankCrownIconHeightScale = 0.28;
static float rankCrownYScale = 0.16;
static NSString* kCrownIconImage = @"CrownIcon";
static float presentYPointOfRankCell;
static float intervalOfCell = 0.14;
static float cellWidthScale = 0.8;
static float cellHeightScale = 0.13;
static float backBtnXScale = 0.004;
static float backBtnWidthScale = 0.15;
static float backbtnHeightScale = 0.1;
static CGSize referenceSize;

static int playerRankPosition;
static int selectedRank;

static NSString* kErrorTitle = @"Can't currently get access to rank";





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ud = [NSUserDefaults standardUserDefaults];
    name = [ud objectForKey:@"Name"];
}

- (void)viewDidAppear:(BOOL)animated{
    self.delegate = (ViewController *)self.parentViewController;
    [self setUpRankView];
    [self loadTop50Rank];
    [self showBanner];
}

- (BOOL)setUpRankView{
    self.rankView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rankViewImage]];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0)];
        self.scrollView.userInteractionEnabled = YES;
        self.rankView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
        referenceSize = self.rankView.frame.size;
        self.rankView.userInteractionEnabled = YES;
        referenceSize = self.rankView.frame.size;
    }else{
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0)];
        self.scrollView.userInteractionEnabled = YES;
        self.rankView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90.0);
        referenceSize = self.rankView.frame.size;
        self.rankView.userInteractionEnabled = YES;
        referenceSize = self.rankView.frame.size;
    }
    [self.scrollView addSubview:self.rankView];
    [self.view addSubview:self.scrollView];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Top50", @"Around You", nil];
    self.segmentedCtr =[[UISegmentedControl alloc] initWithItems:arr];
    self.segmentedCtr.selectedSegmentIndex = 0;
    self.segmentedCtr.tintColor = [UIColor whiteColor];
    CGSize segmentSize = CGSizeMake(referenceSize.width * segmentWidthScale, referenceSize.height * segmentHeightScale);
    self.segmentedCtr.frame = CGRectMake(referenceSize.width / 2.0 - segmentSize.width / 2.0, referenceSize.height * segmentYScale, segmentSize.width, segmentSize.height);
    [self.segmentedCtr addTarget:self action:@selector(changeRankForm:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtr.userInteractionEnabled = YES;
    [self.rankView addSubview:self.segmentedCtr];
    
    CGSize crownSize = CGSizeMake(referenceSize.width * rankCrownIconWidthScale, referenceSize.height * rankCrownIconHeightScale);
    rankCrownIconView = [[UIImageView alloc] initWithFrame:CGRectMake(referenceSize.width / 2.0 - crownSize.width / 2.0, referenceSize.height * rankCrownYScale, crownSize.width, crownSize.height)];
    rankCrownIconView.image = [UIImage imageNamed:kCrownIconImage];
    [self.rankView addSubview:rankCrownIconView];
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(referenceSize.width * backBtnXScale, referenceSize.width * backBtnXScale, referenceSize.width * backBtnWidthScale, referenceSize.height * backbtnHeightScale)];
    [self.backBtn setImage:[UIImage imageNamed:kBackBtnImage] forState:UIControlStateNormal];
    self.backBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.backBtn addTarget:self.delegate action:@selector(moveViewControllerFromRankViewToTitleView) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.backBtn];
    self.backBtn.userInteractionEnabled = YES;

    return YES;
}



- (void)changeRankForm:(UISegmentedControl *)seg{
    if(seg.selectedSegmentIndex == 0){
        [self loadTop50Rank];
    }else{
        [self loadRankAroundPlayer];
    }
}

- (void)uploadRankView:(NSInteger)numberOfCell{
    for (UIView *i in [self.rankView subviews]) {
        if(i == rankCrownIconView || i == self.segmentedCtr)
            continue;
        [i removeFromSuperview];
    }
    float rankViewHeight = referenceSize.height * 0.46 + (referenceSize.height * intervalOfCell * (int)numberOfCell);
    if(rankViewHeight > referenceSize.height){
        self.rankView.frame = CGRectMake(0, 0,referenceSize.width, rankViewHeight);
        self.scrollView.contentSize = self.rankView.bounds.size;
    }
    
    presentYPointOfRankCell = referenceSize.height * 0.46;
    
    CGSize cellSize = CGSizeMake(referenceSize.width * cellWidthScale, referenceSize.height * cellHeightScale);
    float cellXPoint = referenceSize.width / 2.0 - cellSize.width / 2.0;
    for(NCMBObject *n in rankArray){
        RankCellView *cellView = [[RankCellView alloc] initWithFrame:CGRectMake(cellXPoint, presentYPointOfRankCell, cellSize.width, cellSize.height)];
        if(lastObject){
            if([n objectForKey:@"chip"] != [lastObject objectForKey:@"chip"])
                selectedRank += 1;
        }
        [cellView addPlayerRank:selectedRank];
        NSString* selectedName = [n objectForKey:@"name"];
        if([selectedName isEqualToString:name]){
            [cellView addYourName];
        }else{
            [cellView addPlayerName:selectedName];
        }
        NSNumber *chipNumber = [n objectForKey:@"chip"];
        int selectedChip = [chipNumber intValue];
        [cellView addPlayerChip:selectedChip];
        [self.rankView addSubview:cellView];
        presentYPointOfRankCell += referenceSize.height * intervalOfCell;
        lastObject = n;
    
    }
    lastObject = nil;
}


-(void)loadTop50Rank{
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    [self.scrollView addSubview:loadingView];
    [SVProgressHUD showWithStatus:@"loading"];
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    
    //Scoreの降順でデータを取得するように設定
    [query addDescendingOrder:@"chip"];
    
    //検索件数を5件に設定
    query.limit = 50;
    
    //データストアでの検索を行う
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            [loadingView removeFromSuperview];
            [SVProgressHUD dismiss];
            NSString *title = NSLocalizedString(@"error", @"");
            NSString *message = NSLocalizedString(@"Can't currently get access to rank", @"");
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            oKAction.enabled = YES;
            
            [alertController addAction:oKAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:^{
                            }];

        } else {
            rankArray = objects;
            selectedRank = 1;
            [self uploadRankView:rankArray.count];
            [loadingView removeFromSuperview];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)loadRankAroundPlayer{
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    [self.scrollView addSubview:loadingView];
    [SVProgressHUD showWithStatus:@"loading"];
    
    if(!playerRankPosition)
        [self getRankOfPlayer];
    
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    
    //Scoreの降順でデータを取得するように設定
    [query addDescendingOrder:@"chip"];
    
    query.limit = 75;
    if(playerRankPosition - 50 > 0)
        query.skip = playerRankPosition - 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            [loadingView removeFromSuperview];
            [SVProgressHUD dismiss];
            NSString *title = NSLocalizedString(@"error", @"");
            NSString *message = NSLocalizedString(@"Can't currently get access to rank", @"");
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            oKAction.enabled = YES;
            
            [alertController addAction:oKAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:^{
                             }];
            
        } else {
            if(objects.count > 50){
                NSRange range = NSMakeRange(objects.count - 50, objects.count - 1);
                rankArray = [objects subarrayWithRange:range];
            }else{
                rankArray = objects;
            }
            if(playerRankPosition - 50 > 0)
                selectedRank = playerRankPosition - [self getSelectedRankInArray];
            else
                selectedRank = 1;
            [self uploadRankView:rankArray.count];
            [loadingView removeFromSuperview];
            [SVProgressHUD dismiss];
        }
    }];

}


- (int)getSelectedRankInArray{
    int i = 0;
    for(; i < rankArray.count ; i++){
        NCMBObject *object = rankArray[i];
        if([[object objectForKey:@"name"] isEqualToString:name])
            break;
    }
    return i;
}

- (void)getRankOfPlayer{
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Rank"];
    
    [query addDescendingOrder:@"chip"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSString* reason = error.localizedFailureReason;
            NSString *title = NSLocalizedString(kErrorTitle, @"");
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:reason preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            oKAction.enabled = YES;
            
            [alertController addAction:oKAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:^{
                             }];
            
        } else {
            
            for(int i = 0; i < objects.count; i++){
                if([name compare:[objects[i] objectForKey:@"name"]])
                    playerRankPosition = i + 1;
                
            }
            
        }}];

}

- (void)showBanner{
    __weak RankViewController* weakSelf = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/7832007709";
    }else{
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape origin:CGPointMake(0, referenceSize.height)];
        self.bannerView.adUnitID = @"ca-app-pub-8719818866106636/9308740902";
        
    }
    
    self.bannerView.rootViewController = weakSelf;
    
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
