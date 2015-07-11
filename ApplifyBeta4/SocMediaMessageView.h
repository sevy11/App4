//
//  SocMediaMessageView.h
//  ApplifyBeta4
//
//  Created by Michael Sevy on 7/8/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//


//SuperClass for all the types of MessageViews

#import <UIKit/UIKit.h>
#import "SocialMedia.h"
#import "SocMediaTextView.h"

@interface SocMediaMessageView : UIView

@property UIImageView *socMediaTypeView;
@property UIImageView *profileImageView;
@property UIImageView *mainImageView;

@property UILabel *screenNameLabel;
@property UILabel *timeLabel;
@property SocialMedia *mediaContent;
@property SocMediaTextView *textView;

@property NSLayoutConstraint *socMediaTextViewHeightCon;

+ (void)setupContentInTextView:(SocMediaMessageView *)view;
+ (CGRect):defaultContentFrame;
+ (UILabel *)setupLabelWithFont:(UIFont *)font andColor:(UIColor *)fontColor;
+ (UIImageView *)setupImageView;
+ (void)loadImageFromNSDataAndKeyword:(NSString *)keyword imageData:(NSData *)data imageView:(UIImageView *)imageView;

//instance methods

-(void)updateContentWithSocMediaMessage:(SocialMedia *)content;


@end
