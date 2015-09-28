//
//  SocMediaTextView.h
//  ApplifyBeta4
//
//  Created by Michael Sevy on 7/7/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface SocMediaTextView : NSObject

    //public Class methods can be used with just a class name while and instance method need the specific instnace of a class
    + (CGRect)defaultContentFrame;
    + (UIFont *)defaultFont;
    + (UIFont *)largerFont;

    //accessors or instance methods use and instance of a class like [array count]
    -(UITextView *)getTextView;
    -(void)updateContentWithString:(NSString *)content;
    -(int)getLayoutHeightForWidth:(CGFloat)width;

@end
