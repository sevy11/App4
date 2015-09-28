//
//  ShortSocMediaMessageView.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 7/9/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "ShortSocMediaMessageView.h"

@implementation ShortSocMediaMessageView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addConstraintsToTopObjects];
        [self addConstraintsToSocMediaTextView];
        [self addConstraintsToMainImageAndFooter];
    }
    return self;
}

//
-(void)updateContentWithSocMediaMessage:(SocialMedia *)content{
    [super updateContentWithSocMediaMessage:content];

    //update height constraint on the SocMediaTextView
    super.socMediaTextViewHeightCon.constant = [super.textView getLayoutHeightForWidth:275];

    //update height on the textview frame
    CGRect frame = self.frame;
    frame.size.height = [self getLayoutHeight];
    self.frame = frame;


}

#pragma Constraints for all Social Media Message View Objects

-(void)addConstraintsToTopObjects{
    UIImageView *profileImageView = super.profileImageView;
    UIImageView *socMediaTypeImage = super.socMediaTypeView;
    UILabel *screenNameLabel = super.screenNameLabel;
    UILabel *timeLabel = super.timeLabel;

    //removes all auto layout constraints
    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    socMediaTypeImage.translatesAutoresizingMaskIntoConstraints = NO;
    screenNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    //add vertical constraints to profileImageView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[profileImageView]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(profileImageView)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[profileImageView]-4-[screenNameLabel]-4-[timeLabel]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(profileImageView, screenNameLabel, timeLabel)]];
}

//constraints between textView and top objects(screenName)
-(void)addConstraintsToSocMediaTextView{

    UITextView *socMediaTextView = [super.textView getTextView];
    UILabel *screenNameLabel = super.screenNameLabel;
    UIImageView *profileImageView = super.profileImageView;

    socMediaTextView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[socMediaTextView]"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(socMediaTextView)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[socMediaTextView]-[screenNameLabel]"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(socMediaTextView, screenNameLabel)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[profileImageView]-[socMediaTextView]"
                                                                 options:NSLayoutFormatDirectionLeftToRight
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(profileImageView, socMediaTextView)]];

    super.socMediaTextViewHeightCon = [NSLayoutConstraint constraintWithItem:socMediaTextView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:0];
    [self addConstraint:super.socMediaTextViewHeightCon];
}

//main Image Constraints
- (void)addConstraintsToMainImageAndFooter
{
    UITextView *socMediaTextView = [super.textView getTextView];

    UIImageView *mainImageView = super.mainImageView;


    mainImageView.translatesAutoresizingMaskIntoConstraints = NO;

    // add vertical constraints to mainImageView
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[socMediaTextView]-[mainImageView]"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(socMediaTextView, mainImageView)]];
}

-(CGFloat)getLayoutHeight{
    CGFloat profileImageHeight = 5 + super.profileImageView.frame.size.height;
    CGFloat textViewHeight = 10 + [super.textView getLayoutHeightForWidth:275.0];
    CGFloat mainImageHeight = super.mainImageView.frame.size.height;

    return textViewHeight + profileImageHeight + mainImageHeight;
}

@end








