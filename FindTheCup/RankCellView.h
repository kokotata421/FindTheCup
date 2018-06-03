//
//  RankCellView.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/07/01.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCellView : UIImageView

- (void)addPlayerName:(NSString *)name;
- (void)addPlayerRank:(int)rank;
- (void)addPlayerChip:(int)chip;
- (void)addYourName;
@end
