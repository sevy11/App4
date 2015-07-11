//
//  SocMediaTextView.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 7/7/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "SocMediaTextView.h"

@interface SocMediaTextView ()

@property UITextView *textView;

@end

@implementation SocMediaTextView

//class methods
+ (UIFont *)defaultFont {
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)largerFont  {
    return [UIFont systemFontOfSize:16.0];
}

//public instance methods
- (id)init  {
    self = [super init];
    if (self) {
        _textView = [UITextView new];
        _textView.font = [SocMediaTextView defaultFont];
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.editable = NO;
        [_textView setUserInteractionEnabled:NO];
    }
    return self;
}

-(UITextView *)getTextView{
    return _textView;
}

-(void)updateContentWithString:(NSString *)content{
    _textView.text = content;
}

-(int)getLayoutHeightForWidth:(CGFloat)width{
    CGSize size = [_textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;

}




@end



