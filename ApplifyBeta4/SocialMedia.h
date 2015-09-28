//
//  SocialMedia.h
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocialMedia : NSObject

@property NSString *text;
@property NSString *screenName;
@property NSString *source;
@property NSString *timeDiff;
@property float timingDiff;

@property NSData *userPicData;
@property NSData *mainPicData;
@property NSURL *mainPicPageURL;

@property NSString *bookLocation;
@property NSString *bookUserID;
@property BOOL mainImageBool;
@property BOOL isVerified;

@property NSArray *faceboookCommentsArray;


@end
