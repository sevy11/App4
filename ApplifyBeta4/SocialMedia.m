//
//  SocialMedia.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "SocialMedia.h"

@implementation SocialMedia



-(NSString *)whatsMyName:(NSString *)newString{
    NSString *result;
    if ([newString isEqualToString:@"Michael"]) {
        result = @"Cool, can I call you Mike?";
    } else{
        result = @"Dude, not cool";
    }

    return result;
}




@end
