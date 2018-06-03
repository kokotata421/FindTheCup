//
//  Check.h
//  FindTheOne
//
//  Created by Kota Kawanishi on 2016/05/24.
//  Copyright © 2016年 Kota Kawanishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Check : NSObject

+ (BOOL) chkAlphabet:(NSString *)checkString;
+ (BOOL) chkAlphaNumeric:(NSString *)checkString;
+ (BOOL) chkNumeric:(NSString *)checkString;
+ (BOOL) chkAlphaNumericSymbol:(NSString *)checkString;
+ (BOOL) chkMultiByteChar:(NSString *)checkString;

@end
