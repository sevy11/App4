//
//  SocMediaMessageView.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 7/8/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.



//SuperClass for all the types of MessageViews


#import "SocMediaMessageView.h"
#import "Color.h"


@implementation SocMediaMessageView

+ (CGRect)defaultContentFrame
{
    return CGRectMake((7 + 25 + 5), 25, 274, 125);
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [SocMediaMessageView setupContentInTextView:self];
    }
    return self;
}

+ (void)setupContentInTextView:(SocMediaMessageView *)view{
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    //remove all subviews from the UITableViewCell contentView
    [[view subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //add SocMediaTextView and order it to the back
    view.textView = [SocMediaTextView new];
    [view addSubview:[view.textView getTextView]];

    //add profileImage, screenName and timeLabel to view
    view.profileImageView = [SocMediaMessageView setupImageView];
    view.screenNameLabel = [SocMediaMessageView setupLabelWithFont:[UIFont boldSystemFontOfSize:12.0] andColor:[Color fontBlack]];
    view.timeLabel = [SocMediaMessageView setupLabelWithFont:[UIFont systemFontOfSize:12.0] andColor:[Color fontGray]];
    view.mainImageView = [SocMediaMessageView setupImageView];
    [view addSubview:view.timeLabel];
    [view addSubview:view.profileImageView];
    [view addSubview:view.timeLabel];
    [view addSubview:view.mainImageView];

}
//update content and constraints on subviews

- (void)updateContentWithSocMediaMessage:(SocialMedia *)content{
    _mediaContent = content;

    //update Subviews
//    [SocMediaMessageView loadImageFromNSDataAndKeyword:<#(NSString *)#> imageData:<#(NSData *)#> imageView:<#(UIImageView *)#>:content.userPicData imageView:_profileImageView];
    _screenNameLabel.text = content.screenName;
    _timeLabel.text = content.timeDiff;
    

}

+ (UILabel *)setupLabelWithFont:(UIFont *)font andColor:(UIColor *)fontColor{
    UILabel *label = [UILabel new];
    label.font = font;
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = NO;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = fontColor;
    label.textAlignment = NSTextAlignmentLeft;

    return label;
}

+ (UIImageView *)setupImageView{
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4.0;
    return imageView;
}

+ (void)loadImageFromNSDataAndKeyword:(NSString *)keyword imageData:(NSData *)data imageView:(UIImageView *)imageView {


}




#pragma helper methods



@end





