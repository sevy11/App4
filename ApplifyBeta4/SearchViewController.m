//
//  SearchViewController.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 8/13/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "SearchViewController.h"
#import "SocialMedia.h"
#import "SocialMediaTableViewCell.h"
#import "Color.h"


@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property NSArray *twitterArray;

@property NSMutableArray *socialMediaArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;

    self.navigationController.hidesBarsOnSwipe = YES;

    self.socialMediaArray = [NSMutableArray new];
    NSLog(@"search page");
    [self performTweetSearchWithKeyword:self.searchTextField.text];
    //    [self performFacebookSearchWithKeyword:@"P%5C!nk"];

    NSLog(@"search page two");
    //setup navigation bar
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar setBarTintColor:[Color twitterBlue]];
    self.navigationController.navigationBar.tintColor = [Color fontWhite];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [Color fontWhite]}];

    //setup tab bar
    self.tabBarController.tabBar.barTintColor = [Color twitterBlue];
    self.tabBarController.tabBar.tintColor = [Color fontWhite];
    



}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SocialMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    SocialMedia *socMedia = [self.socialMediaArray objectAtIndex:indexPath.row];

    //constraints from cell views
    [cell configureObjectInCell];

    cell.screenName.text = socMedia.screenName;
    cell.textViewForText.text = socMedia.text;
    cell.timeLabel.text = socMedia.timeDiff;
    cell.userImage.image = [UIImage imageWithData:socMedia.userPicData];

    NSLog(@"Data from cells draw: %@, %@, %@", socMedia.screenName, socMedia.text, socMedia.mainImageBool ? @"Yes" : @"No");



    //setting up a loop through a second variable to check if a mainPic exists on each run through of a tweet
    int socDigit;

    if (socMedia.mainImageBool == YES) {
        socDigit = 1;
    } else{
        socDigit = 0;
    }

    switch (socDigit) {
        case 1:
            cell.mainImage.image = [UIImage imageWithData:socMedia.mainPicData];
            cell.mainImage.contentMode = UIViewContentModeScaleAspectFit;
            cell.mainImage.layer.masksToBounds = YES;

            [cell mainImageHeightAndWidth];

            self.tableView.rowHeight = cell.userImage.frame.size.height + cell.screenName.frame.size.height + cell.timeLabel.frame.size.height + cell.textViewForText.frame.size.height + cell.mainImage.frame.size.height;//with mainImage height

            break;
        case 0:
            [cell.imageView removeFromSuperview];
            self.tableView.rowHeight = cell.userImage.frame.size.height + cell.screenName.frame.size.height + cell.timeLabel.frame.size.height + cell.textViewForText.frame.size.height;//without mainImage height
            break;

        default:
            cell.mainImage.backgroundColor = [UIColor greenColor];
            break;

    }

    //choose social media logo
    if ([socMedia.source containsString:@"twitter"]) {
        cell.socialMediaImage.image = [UIImage imageNamed:@"Twitter_logo_blue"];
    } else if ([socMedia.bookLocation containsString:@"Not supported yet!"]){
        cell.socialMediaImage.image = [UIImage imageNamed:@"FB-f-Logo__blue_29"];
    }
    
    return cell;


}



- (void)performTweetSearchWithKeyword:(NSString *)incomingString  {


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://intutvp.herokuapp.com/intutv/api/v1.0/search/twitter/%@",incomingString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            self.twitterArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
            NSLog(@"%@", data);
            NSLog(@"search page three");
            
            //loop through JSON array
            for (NSArray *array in self.twitterArray) {

                NSDictionary *item = array[1];
                SocialMedia *socialMedia = [SocialMedia new];

                //tweet body
                NSString *text = item[@"text"];
                socialMedia.text = text;
                //  NSLog(@"%@", socMedia.text);

                NSString *source = item[@"source"];
                socialMedia.source = source;

                //screen Name
                NSDictionary *user = item[@"user"];
                NSString *screenName = user[@"screen_name"];
                NSString *screenNameAt = [NSString stringWithFormat:@"@%@", screenName];
                socialMedia.screenName = screenNameAt;
                //NSLog(@"%@", socMedia.screenName);

                //....MAIN PIC......//
                NSDictionary *entities = item[@"entities"];
                if ([entities objectForKey:@"media"]) {
                    //  NSLog(@"main Image found on query level");
                    socialMedia.mainImageBool = YES;

                    //pulling out mainImage data from self.media array by loop
                    NSArray *media = entities[@"media"];
                    for (NSDictionary *itemy in media) {

                        NSString *mediaURLString = itemy[@"media_url"];
                        NSURL *mediaURL = [NSURL URLWithString:mediaURLString];
                        socialMedia.mainPicData = [NSData dataWithContentsOfURL:mediaURL];
                    }

                } else {
                    socialMedia.mainImageBool = NO;
                }

                //Profile Pic
                NSString *userPicURL = user[@"profile_image_url_https"];
                NSURL *profileURL = [NSURL URLWithString:userPicURL];
                NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
                socialMedia.userPicData = profileData;

                //Time
                NSString *createdAt = item[@"created_at"];
                NSLog(@"twitter time:%@", createdAt);
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
                NSDate *tweetDate = [NSDate new];
                tweetDate = [formatter dateFromString:createdAt];
                NSDate *nowDate = [NSDate date];
                NSDateFormatter *format = [NSDateFormatter new];
                [format setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];

                socialMedia.timingDiff = [nowDate timeIntervalSinceDate:tweetDate];

                if (socialMedia.timingDiff < 1) {
                    socialMedia.timeDiff = [NSString stringWithFormat:@"now"];
                } else if (socialMedia.timingDiff < 60){
                    socialMedia.timeDiff = [NSString stringWithFormat:@"%fs", socialMedia.timingDiff];
                } else if (socialMedia.timingDiff < 3600){
                    int diffRound = round(socialMedia.timingDiff / 60);
                    socialMedia.timeDiff = [NSString stringWithFormat:@"%dm", diffRound];
                } else if (socialMedia.timingDiff < 86400){
                    int diffRound = round(socialMedia.timingDiff / 60 / 60);
                    socialMedia.timeDiff = [NSString stringWithFormat:@"%dh", diffRound];
                } else if (socialMedia.timingDiff < 2629743){
                    int diffRound = round(socialMedia.timingDiff / 60 / 60 / 24);
                    socialMedia.timeDiff = [NSString stringWithFormat:@"%dd", diffRound];
                } else if (socialMedia.timingDiff < 18408201) {
                    int diffRound = round(socialMedia.timingDiff / 60 / 60 / 24 / 7);
                    socialMedia.timeDiff = [NSString stringWithFormat:@"%dw", diffRound];
                } else{
                    socialMedia.timeDiff = [NSString stringWithFormat:@"Over a week"];
                }

                //                NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:item[@"created_at"] ascending:NO];
                //                NSArray *sortedArray = [NSArray arrayWithObject:sorter];
                //                NSLog(@"sorting... %@", sortedArray);
                
                [self.socialMediaArray addObject:socialMedia];
                
                [self.tableView reloadData];
            }
        }
    }];
}



@end








