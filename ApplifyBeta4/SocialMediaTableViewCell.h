//
//  SocialMediaTableViewCell.h
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialMedia.h"


@interface SocialMediaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *textViewForText;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *socialMediaImage;

//class methods
-(NSData *)imageForMainPic:(BOOL) mainImage;

-(void)mainImageHeightAndWidth;
-(void)configureObjectInCell;
-(void)removeMainImageFromView;
-(void)rowHeightForNoImage;

@end


