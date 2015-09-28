//
//  SocialMediaTableViewCell.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "SocialMediaTableViewCell.h"
#import "SocialMedia.h"
#import "ShortSocMediaMessageView.h"
#import "SocMediaMessageView.h"
#import "Color.h"

@interface SocialMediaTableViewCell ()

@property ShortSocMediaMessageView *view;

@end

@implementation SocialMediaTableViewCell


-(NSData *)imageForMainPic:(BOOL) mainImage{

    SocialMedia *soc = [SocialMedia new];
    NSData *mainPicData;
    if (mainImage == YES) {
        mainPicData = soc.mainPicData;
    } else{
        mainPicData = nil;
    }
    return mainPicData;
}




-(void)removeMainImageFromView{
    UIImageView *mainImage = _mainImage;

    [mainImage removeFromSuperview];
    mainImage = nil;
}

-(void)configureObjectInCell{

    UIImageView *profileView = _userImage;
    UILabel *screenName = _screenName;
    UIImageView *socMediaPic = _socialMediaImage;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[profileView]-5-[socMediaPic]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(profileView, socMediaPic)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[profileView]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(profileView)]];

    [self.view addSubview:socMediaPic];
    [self.view addSubview:screenName];

}

-(void)rowHeightForNoImage{


    UIImageView *mainImage = _mainImage;

  //  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainImage]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(mainImage)]];

    [self.view addSubview:mainImage];

}

-(void)mainImageHeightAndWidth{
    UIImageView *mainImageView = _mainImage;
    UITextView *textView = _textViewForText;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textView]-2-[mainImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mainImageView, textView)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[mainImageView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mainImageView)]];

    [self.view addSubview:mainImageView];
    [self.view addSubview:textView];

//    float widthRatio = mainImageView.bounds.size.width / mainImageView.image.size.width;
//    float heightRatio = mainImageView.bounds.size.height / mainImageView.image.size.height;
//    float scale = MIN(widthRatio, heightRatio);
//    float imageWidth = scale * mainImageView.image.size.width;
//    float imageHeight = scale * mainImageView.image.size.height;


}

@end










