//
//  RankCellView.m
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/07/01.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import "RankCellView.h"
#import "Check.h"

@interface RankCellView(){
    UIImageView *chipIconView;
    
}

@property(assign) float presentXPoint;

@end

@implementation RankCellView {
    
}



typedef struct{ float width; float height;} sizeScale;

static NSString* kCellImage = @"RankCellView";
static NSString* kChipImage = @"Chip";
static NSString* kChipIconImage = @"ChipIcon";
static NSString* kGoldCrownIconImage = @"GoldCrownIcon";
static NSString* kSilverCrownIconImage = @"SilverCrownIcon";
static NSString* kCopperCrownIconImage = @"CopperCrownIcon";


static float widthScale[4][36] = {{0.0363, 0.03057, 0.02993, 0.03375, 0.02929, 0.02866, 0.03375, 0.03439, 0.01538, 0.02802, 0.0363, 0.02802, 0.03821, 0.03566, 0.03248, 0.02929, 0.03248, 0.03375, 0.02675, 0.03121, 0.03053, 0.03566, 0.04649, 0.03503, 0.03439, 0.02993},{0.0242, 0.02738, 0.02229, 0.02738, 0.02229, 0.01847, 0.02484, 0.02929, 0.01464, 0.01337, 0.03184, 0.01528, 0.04203, 0.02929, 0.02547, 0.02866, 0.02738, 0.02356, 0.0191, 0.02038, 0.02929, 0.02866, 0.04588, 0.02675, 0.02738, 0.02229},{0.02292, 0.02547, 0.02547, 0.02484, 0.02356, 0.02547, 0.02484, 0.02547, 0.02547, 0.0242},{0.02356, 0.01592, 0.01019, 0.02165, 0.03821, 0.02101, 0.02292, 0.01528, 0.01528, 0.01019, 0.02229, 0.01273, 0.02101, 0.0114, 0.008, 0.0191 , 0.0191, 0.02038, 0.034, 0.02229, 0.01847, 0.021, 0.01082, 0.03312, 0.02738, 0.01019, 0.01082, 0.01847, 0.01847, 0.01082, 0.02611, 0.02611, 0.0191, 0.0191, 0.02101, 0.01}};
static float heightScale[4][36] = {{0.44, 0.432, 0.44, 0.432, 0.44, 0.432, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.552, 0.448, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44,0.44},{0.32, 0.432, 0.32, 0.432, 0.32, 0.44, 0.448, 0.432, 0.432, 0.552, 0.432, 0.432, 0.312, 0.312, 0.32, 0.424, 0.432, 0.32, 0.32, 0.392, 0.312, 0.32, 0.32, 0.312, 0.416, 0.328},{0.408, 0.428, 0.432, 0.44, 0.424, 0.432, 0.456, 0.424, 0.44, 0.424},{0.48, 0.192, 0.432, 0.16, 0.488, 0.192, 0.408, 0.552, 0.552, 0.144, 0.08, 0.12, 0.312, 0.05777, 0.536, 0.552, 0.552, 0.432, 0.43, 0.224, 0.256, 0.552, 0.216, 0.44, 0.48, 0.328, 0.432, 0.552, 0.552, 0.256, 0.48, 0.48, 0.44, 0.44, 0.552, 0.104}};
static float yScale[4][36] = {{0.4124, 0.4191, 0.4124, 0.4166, 0.4124, 0.4191, 0.4124, 0.4124, 0.4124, 0.4166, 0.4124, 0.4166, 0.4124, 0.4124, 0.4124, 0.4166, 0.4124, 0.4124, 0.4124, 0.4124, 0.4166, 0.4166, 0.4166, 0.4166, 0.4124, 0.4124},{0.5314, 0.4179, 0.5314, 0.4179,0.5314, 0.411, 0.5116,0.4179, 0.4179, 0.4179, 0.4179, 0.4179, 0.5357, 0.5357,0.5314, 0.5314 ,0.5314, 0.5314, 0.5314, 0.4595,0.5357,0.5314, 0.5314, 0.5357, 0.5357, 0.5266},{0.4459, 0.4301, 0.4221, 0.4141, 0.4301, 0.4204, 0.3981, 0.4141, 0.4141, 0.4301, 0.44,},{0.3665, 0.2998, 0.3625, 0.4335, 0.3284, 0.4525, 0.3819, 0.2792, 0.2792, 0.6727, 0.7652, 0.5058, 0.3922, 0.2874, 0.303, 0.2794, 0.2794, 0.3557, 0.3213, 0.299, 0.297, 0.2992, 0.3051, 0.3665, 0.3633, 0.4002, 0.4002, 0.289, 0.289, 0.6727, 0.3665, 0.3665, 0.3407, 0.3407, 0.2927, 0.55}};
static float youWidthSizeScale = 0.1082;
static float youHeightSizeScale = 0.44;
static float youYScale = 0.4124;
static float intervalBetweenCapitalScale = 0.001;
static float intervalBetweenStringScale = 0.003;
static float intervalBetweenSymbolScale = 0.007;
static float intervalOfSpace = 0.014;

static float startXpointScaleOfName = 0.1;
static NSString* symbolCharacters = @"$\"!~&=#[]._-+`|{}?%^*/'@¥:;(),€£<>\\• ";
static float widthScaleOfChip = 0.02547;
static float heightScaleOfChip = 0.464;
static float xScaleOfChip[7] = {0.88345, 0.85441, 0.82737, 0.79806, 0.77179, 0.74508, 0.71785};
static float yScaleOfChip = 0.39;
static float chipWidthScale = 0.07452;
static float chipHeightScale = 0.472;
static float chipXScale = 0.91146;
static float chipYScale = 0.48;
static float chipIconSizeScaleToWidth = 0.05414;
static float chipIconXScale = 0.02;
static sizeScale rankNumberSizeScale1 = {0.01401, 0.288};
static sizeScale rankNumberSizeScale2 = {0.01146, 0.278};
static sizeScale rankNumberSizeScale3 = {0.008927, 0.268};
static sizeScale rankNumberSizeScale4 = {0.006369, 0.258};
static sizeScale rankNumberSizeScale5 = {0.003813, 0.258};
static float rankNumberXScaleToChip2[2] = {0.51176, 0.27647};
static float rankNumberXScaleToChip3[3] = {0.59411, 0.41764, 0.24117};
static float rankNumberXScaleToChip4[4] = {0.63529, 0.50588, 0.38647, 0.24795};
static float rankNumberXScaleToChip5[5] = {0.6609, 0.5557, 0.45047, 0.34523, 0.24};
static float chipIconSize;
static sizeScale rankCrownIconSizeScaleToChipIcon = {0.5294, 0.4117};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
        self.image = [UIImage imageNamed:kCellImage];
    
    return self;
}

- (void)addPlayerName:(NSString *)name{
    self.presentXPoint = self.frame.size.width * startXpointScaleOfName;
    for(int i = 0; i < [name length]; i++){
        NSString* n = [name substringWithRange:NSMakeRange(i, 1)];
        if([Check chkAlphabet:n])
            [self addAlphabetCharacter:n];
        else if([Check chkNumeric:n])
            [self addNumericCharacter:n];
        else
            [self addSymbolCharacter:n];
    }
}

- (void)addYourName{
    self.presentXPoint = self.frame.size.width * startXpointScaleOfName;
    UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"You"]];
    i.frame = CGRectMake(self.presentXPoint, self.frame.size.height * youYScale, self.frame.size.width * youWidthSizeScale,self.frame.size.height * youHeightSizeScale);
    [self addSubview:i];
}

- (void)addPlayerRank:(int)rank{
    chipIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kChipIconImage]];
    chipIconSize = self.frame.size.width * chipIconSizeScaleToWidth;
    chipIconView.frame = CGRectMake(self.frame.size.width * chipIconXScale, self.frame.size.height / 2.0 - chipIconSize / 2.0, chipIconSize, chipIconSize);
    [self addSubview:chipIconView];
    
    UIImageView *rankNumberView = [[UIImageView alloc] init];
    if(rank <= 3){
        switch (rank) {
            case 1: rankNumberView.image = [UIImage imageNamed:kGoldCrownIconImage]; break;
            case 2: rankNumberView.image = [UIImage imageNamed:kSilverCrownIconImage]; break;
            case 3: rankNumberView.image = [UIImage imageNamed:kCopperCrownIconImage]; break;
            default: break;
        }
        CGSize crownSize = CGSizeMake(chipIconSize * rankCrownIconSizeScaleToChipIcon.width, chipIconSize * rankCrownIconSizeScaleToChipIcon.height);
        rankNumberView.frame = CGRectMake(chipIconSize / 2.0 - crownSize.width / 2.0, chipIconSize / 2.0 - crownSize.height / 2.0, crownSize.width, crownSize.height);
        [chipIconView addSubview:rankNumberView];
        return;
    }
    [self addPlayerRankNumber:rank];
    
}

- (void)addPlayerChip:(int)chip{
    int j = 0;
    int n = chip;
    do{
        int i = n % 10;
        UIImageView *number = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", i]]];
        number.frame = CGRectMake(self.frame.size.width * xScaleOfChip[j], self.frame.size.height * yScaleOfChip, self.frame.size.width * widthScaleOfChip, self.frame.size.height * heightScaleOfChip);
        
        [self addSubview:number];
        j += 1;
        n /= 10;
    }while(n >= 1);
    
    UIImageView *chipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kChipImage]];
    chipImageView.frame = CGRectMake(self.frame.size.width * chipXScale, self.frame.size.height * chipYScale, self.frame.size.width * chipWidthScale, self.frame.size.height * chipHeightScale);
    [self addSubview:chipImageView];
}

- (void)addPlayerRankNumber:(int)number{
    int n = number;
    
    if(number >= 10000){
        CGSize numberSize = CGSizeMake(self.frame.size.width * rankNumberSizeScale5.width, self.frame.size.height * rankNumberSizeScale4.height);
        float chipYPoint = chipIconSize / 2.0 - numberSize.height / 2.0;
        for(int i = 0; i < 5; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(chipIconSize * rankNumberXScaleToChip5[i], chipYPoint, numberSize.width, numberSize.height)];
            numberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", n % 10]];
            [chipIconView addSubview:numberView];
            n /= 10;
        }

    }else if(number >= 1000){
        CGSize numberSize = CGSizeMake(self.frame.size.width * rankNumberSizeScale4.width, self.frame.size.height * rankNumberSizeScale4.height);
        float chipYPoint = chipIconSize / 2.0 - numberSize.height / 2.0;
        for(int i = 0; i < 4; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(chipIconSize * rankNumberXScaleToChip4[i], chipYPoint, numberSize.width, numberSize.height)];
            numberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", n % 10]];
            [chipIconView addSubview:numberView];
            n /= 10;
        }
    }else if(number >= 100){
        CGSize numberSize = CGSizeMake(self.frame.size.width * rankNumberSizeScale3.width, self.frame.size.height * rankNumberSizeScale3.height);
        float chipYPoint = chipIconSize / 2.0 - numberSize.height / 2.0;
        for(int i = 0; i < 3; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(chipIconSize * rankNumberXScaleToChip3[i], chipYPoint, numberSize.width, numberSize.height)];
            numberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", n % 10]];
            [chipIconView addSubview:numberView];
            n /= 10;
        }

    }else if(number >= 10){
        CGSize numberSize = CGSizeMake(self.frame.size.width * rankNumberSizeScale2.width, self.frame.size.height * rankNumberSizeScale2.height);
        float chipYPoint = chipIconSize / 2.0 - numberSize.height / 2.0;
        for(int i = 0; i < 2; i++){
            UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(chipIconSize * rankNumberXScaleToChip2[i], chipYPoint, numberSize.width, numberSize.height)];
            numberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", n % 10]];
            [chipIconView addSubview:numberView];
            n /= 10;
        }
    }else {
        CGSize numberSize = CGSizeMake(self.frame.size.width * rankNumberSizeScale1.width, self.frame.size.height * rankNumberSizeScale1.height);
        float chipXpoint = chipIconSize / 2.0 - numberSize.width / 2.0;
        float chipYPoint = chipIconSize / 2.0 - numberSize.height / 2.0;
        UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(chipXpoint, chipYPoint, numberSize.width, numberSize.height)];
            numberView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d_RankCell", n % 10]];
        [chipIconView addSubview:numberView];
        
    }
}

- (void)addAlphabetCharacter:(NSString *)n{
    if(isupper([n characterAtIndex:0])){
        
        NSString* image = [NSString stringWithFormat:@"RankCharacter_%@", n];
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        int number = [n characterAtIndex:0] - [@"A" characterAtIndex:0];
        i.frame = CGRectMake(self.presentXPoint, self.frame.size.height * yScale[0][number],self.frame.size.width * widthScale[0][number],self.frame.size.height * heightScale[0][number]);
        self.presentXPoint += self.frame.size.width * widthScale[0][number] + intervalBetweenCapitalScale;
        [self addSubview:i];
    }else {
        NSString* image = [NSString stringWithFormat:@"RankCharacter_%@-1", n];
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        int number = [n characterAtIndex:0] - [@"a" characterAtIndex:0];
        i.frame = CGRectMake(self.presentXPoint,self.frame.size.height * yScale[1][number], self.frame.size.width * widthScale[1][number],self.frame.size.height * heightScale[1][number]);
        self.presentXPoint += widthScale[1][number] * self.frame.size.width + intervalBetweenStringScale;
        [self addSubview:i];
    }
        
}

- (void)addNumericCharacter:(NSString *)n{
    NSString* image = [NSString stringWithFormat:@"RankCharacter_%@", n];
    UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    int number = [n intValue] - [@"0" intValue];
    i.frame = CGRectMake(self.presentXPoint, self.frame.size.height * yScale[2][number],self.frame.size.width * widthScale[2][number],self.frame.size.height * heightScale[2][number]);
    self.presentXPoint += self.frame.size.width * widthScale[2][number] + intervalBetweenStringScale;
    [self addSubview:i];
}

- (void)addSymbolCharacter:(NSString *)n{
    if([n  compare:@""] == NSOrderedSame){
        self.presentXPoint += self.frame.size.width * intervalOfSpace;
    }else if([n compare:@"/"] == NSOrderedSame){
        NSString* image = [NSString stringWithFormat:@"RankCharacter_slush"];
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        NSRange range = [symbolCharacters rangeOfString:n];
        int number = (int)range.location;
        i.frame = CGRectMake(self.presentXPoint,self.frame.size.height * yScale[3][number], self.frame.size.width * widthScale[3][number],self.frame.size.height * heightScale[3][number]);
        self.presentXPoint += self.frame.size.width * widthScale[3][number] + intervalBetweenSymbolScale;
        [self addSubview:i];
    }else{
        NSString* image = [NSString stringWithFormat:@"RankCharacter_%@", n];
        if([n compare:@"-"] == NSOrderedSame)
            image = [NSString stringWithFormat:@"RankCharacter__"];
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        NSRange range = [symbolCharacters rangeOfString:n];
        int number = (int)range.location;
    
        
        i.frame = CGRectMake(self.presentXPoint,self.frame.size.height * yScale[3][number], self.frame.size.width * widthScale[3][number],self.frame.size.height * heightScale[3][number]);
        self.presentXPoint += self.frame.size.width * widthScale[3][number] + intervalBetweenSymbolScale;
        [self addSubview:i];
    }
        
    
}
@end
