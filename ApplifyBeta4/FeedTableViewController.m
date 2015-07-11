//
//  FeedTableViewController.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "FeedTableViewController.h"
#import "SocialMedia.h"
#import "SocialMediaTableViewCell.h"
#import <Parse/Parse.h>

@interface FeedTableViewController ()

@property NSMutableArray *socialMediaArray;


@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"User %@, is logged in", currentUser);
    } else{
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }


    self.socialMediaArray = [NSMutableArray new];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self performTweetSearchWithKeyword:@"mom"];
    [self.navigationController.navigationBar setHidden:NO];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.socialMediaArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SocialMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SocialMedia *socMedia = [self.socialMediaArray objectAtIndex:indexPath.row];

    cell.screenName.text = socMedia.screenName;

    cell.textViewForText.text = socMedia.text;
    //[self textViewDidChange:cell.textViewForText];
    [cell.textViewForText intrinsicContentSize];
    //[self contentSizeRectForTextView:cell.textViewForText];


    cell.timeLabel.text = socMedia.timeDiff;

    //main image conditional
    if (socMedia.mainImageBool == YES) {
        cell.mainImage.image = [UIImage imageWithData:socMedia.mainPicData];
        NSLog(@"........PIC.........");

    } else if (socMedia.mainImageBool == NO) {
        NSLog(@"..NO pic..");

    }
    //social media logo conditional
    if ([socMedia.source containsString:@"twitter"]) {
        cell.socialMediaImage.image = [UIImage imageNamed:@"Twitter_logo_blue"];

    } else if ([socMedia.source containsString:@"Facebook"]){
        cell.socialMediaImage.image = [UIImage imageNamed:@"FB-f-Logo__blue_29"];

    }


    return cell;

}


#pragma mark - helper methods
- (void)performTweetSearchWithKeyword:(NSString *)incomingString  {


    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://intutvp.herokuapp.com/intutv/api/v1.0/search/twitter/%@",incomingString]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            NSArray *twitterArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

            //loop through JSON array
            for (NSArray *array in twitterArray) {

                NSDictionary *item = array[1];
                SocialMedia *socMedia = [SocialMedia new];

                NSString *text = item[@"text"];
                socMedia.text = text;
                NSLog(@"%@", socMedia.text);

                NSString *source = item[@"source"];
                socMedia.source = source;

                NSDictionary *user = item[@"user"];
                NSString *screenName = user[@"screen_name"];
                NSString *screenNameAt = [NSString stringWithFormat:@"@%@", screenName];
                socMedia.screenName = screenNameAt;
                NSLog(@"%@", socMedia.screenName);

                //....MAIN PIC......//
                NSDictionary *entities = item[@"entities"];
                if ([entities objectForKey:@"media"]) {
                    NSLog(@"main Image found on query level");
                    socMedia.mainImageBool = YES;

                    //pulling out mainImage data from self.media array by loop
                    NSArray *media = entities[@"media"];
                    for (NSDictionary *itemy in media) {

                        NSString *mediaURLString = itemy[@"media_url"];
                        NSURL *mediaURL = [NSURL URLWithString:mediaURLString];
                        socMedia.mainPicData = [NSData dataWithContentsOfURL:mediaURL];
                    }

                } else {
                    NSLog(@".......NO main Image found on query level......");
                    socMedia.mainImageBool = NO;
                }

                //profile pic

                //time
                NSString *createdAt = item[@"created_at"];
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
                NSDate *tweetDate = [NSDate new];
                tweetDate = [formatter dateFromString:createdAt];
                NSDate *nowDate = [NSDate date];
                NSDateFormatter *format = [NSDateFormatter new];
                [format setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];

                socMedia.timingDiff = [nowDate timeIntervalSinceDate:tweetDate];

                if (socMedia.timingDiff < 1) {
                    socMedia.timeDiff = [NSString stringWithFormat:@"Error"];
                } else if (socMedia.timingDiff < 60){
                    socMedia.timeDiff = [NSString stringWithFormat:@"%fs", socMedia.timingDiff];
                } else if (socMedia.timingDiff < 3600){
                    int diffRound = round(socMedia.timingDiff / 60);
                    socMedia.timeDiff = [NSString stringWithFormat:@"%dm", diffRound];
                } else if (socMedia.timingDiff < 86400){
                    int diffRound = round(socMedia.timingDiff / 60 / 60);
                    socMedia.timeDiff = [NSString stringWithFormat:@"%dh", diffRound];
                } else if (socMedia.timingDiff < 2629743){
                    int diffRound = round(socMedia.timingDiff / 60 / 60 / 24);
                    socMedia.timeDiff = [NSString stringWithFormat:@"%dd", diffRound];
                } else if (socMedia.timingDiff < 18408201) {
                    int diffRound = round(socMedia.timingDiff / 60 / 60 / 24 / 7);
                    socMedia.timeDiff = [NSString stringWithFormat:@"%dw", diffRound];
                } else{
                    socMedia.timeDiff = [NSString stringWithFormat:@"Over a week"];
                }

                [spinner stopAnimating];

                [self.socialMediaArray addObject:socMedia];

                [self.tableView reloadData];

            }

        }

        
    }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //check idenifier if more than one
    if ([segue.identifier isEqualToString:@"SignInSegue"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
- (IBAction)onLogoutTapped:(UIBarButtonItem *)sender {

    [PFUser logOut];
    [self performSegueWithIdentifier:@"SignInSegue" sender:self];
}

@end











