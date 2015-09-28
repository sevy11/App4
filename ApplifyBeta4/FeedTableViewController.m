//
//  FeedTableViewController.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/24/1
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "FeedTableViewController.h"
#import "SocialMedia.h"
#import "SocialMediaTableViewCell.h"
#import "SocMediaMessageView.h"
#import "SocMediaTextView.h"
#import "ShortSocMediaMessageView.h"
#import <Parse/Parse.h>
#import "Color.h"

static NSString *const cellIdentifier = @"Cell";

@interface FeedTableViewController ()  <NSURLConnectionDataDelegate>

@property NSMutableArray *socialMediaArray;
@property BOOL socMediaStartLoading;
@property NSArray *twitterArray;
@property NSArray *facebookArray;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"stroyboard: %@", self.storyboard);
    //check if user is logged in, if not send to sign in page
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"User %@, is logged in", currentUser);
    } else{
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }

    //set delegate for tableview and initilize soc media array object
    [self.tableView setDelegate:self];
    self.socialMediaArray = [NSMutableArray new];
    self.twitterArray = [NSArray new];
    self.facebookArray = [NSArray new];


    //setup navigation bar
    self.navigationController.hidesBarsOnSwipe = YES;//hides nav bar when scrolling down
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar setBarTintColor:[Color twitterBlue]];
    self.navigationController.navigationBar.tintColor = [Color fontWhite];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [Color fontWhite]}];

    //setup tab bar
    self.tabBarController.tabBar.barTintColor = [Color twitterBlue];
    self.tabBarController.tabBar.tintColor = [Color fontWhite];

    [self performTweetSearchWithKeyword:@"trump"];
    [self performFacebookSearchWithKeyword:@"demi%20lovoto"];
    //space = %20
    // [self performFacebookSearchWithKeyword:@"P%5C!nk"];

    //dynamically sizing cell not working properly********
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 50;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    self.navigationController.hidesBarsOnSwipe = YES;
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




#pragma mark - helper methods
- (void)performTweetSearchWithKeyword:(NSString *)incomingString  {


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://intutvp.herokuapp.com/intutv/api/v1.0/search/twitter/%@",incomingString]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            self.twitterArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

            //loop through JSON array
            for (NSArray *array in self.twitterArray) {

                NSDictionary *item = array[1];
                SocialMedia *socMedia = [SocialMedia new];

                //tweet body
                NSString *text = item[@"text"];
                socMedia.text = text;
              //  NSLog(@"%@", socMedia.text);

                NSString *source = item[@"source"];
                socMedia.source = source;

                //screen Name
                NSDictionary *user = item[@"user"];
                NSString *screenName = user[@"screen_name"];
                NSString *screenNameAt = [NSString stringWithFormat:@"@%@", screenName];
                socMedia.screenName = screenNameAt;
                //NSLog(@"%@", socMedia.screenName);

                //....MAIN PIC......//
                NSDictionary *entities = item[@"entities"];
                if ([entities objectForKey:@"media"]) {
                  //  NSLog(@"main Image found on query level");
                    socMedia.mainImageBool = YES;

                    //pulling out mainImage data from self.media array by loop
                    NSArray *media = entities[@"media"];
                    for (NSDictionary *itemy in media) {

                        NSString *mediaURLString = itemy[@"media_url"];
                        NSURL *mediaURL = [NSURL URLWithString:mediaURLString];
                        socMedia.mainPicData = [NSData dataWithContentsOfURL:mediaURL];
                    }

                } else {
                    //NSLog(@".......NO main Image found on query level......");
                    socMedia.mainImageBool = NO;
                }

                //Profile Pic
                NSString *userPicURL = user[@"profile_image_url_https"];
                NSURL *profileURL = [NSURL URLWithString:userPicURL];
                NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
                socMedia.userPicData = profileData;
               // NSLog(@"Profile Pic from Feed: %@", userPicURL);

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

                socMedia.timingDiff = [nowDate timeIntervalSinceDate:tweetDate];

                if (socMedia.timingDiff < 1) {
                    socMedia.timeDiff = [NSString stringWithFormat:@"now"];
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

//                NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:item[@"created_at"] ascending:NO];
//                NSArray *sortedArray = [NSArray arrayWithObject:sorter];
//                NSLog(@"sorting... %@", sortedArray);

                [self.socialMediaArray addObject:socMedia];

                [self.tableView reloadData];
                }
            }
        }];
    }


#pragma mark -- facebook JSON
- (void)performFacebookSearchWithKeyword:(NSString *)incomingString  {


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://intutvp.herokuapp.com/v1.0/search/facebook/%@",incomingString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            NSDictionary *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

            NSArray *bookData = objects[@"data"];

            for (NSDictionary *item in bookData) {

                SocialMedia *socBookMedia = [SocialMedia new];

                NSString *bookLocation = item[@"location"];
                socBookMedia.bookLocation = bookLocation;

                NSString *message = item[@"message"];
                socBookMedia.text = message;
                //NSLog(@"Facebook body text: %@", socBookMedia.text);

                //screen Name
                NSDictionary *from = item[@"from"];
                NSString *screenName = from[@"name"];
                socBookMedia.screenName = screenName;
                NSLog(@"Facebook username: %@", socBookMedia.screenName);

                //need a way to get the picture from the user id
                NSString *userID = item[@"id"];
                socBookMedia.bookUserID = userID;


                //....MAIN PIC......//
                NSString *picture = item[@"picture"];
                NSURL *mainPicURL = [NSURL URLWithString:picture];
                NSData *mainPicData = [NSData dataWithContentsOfURL:mainPicURL];
                socBookMedia.mainPicData = mainPicData;
                socBookMedia.mainImageBool = YES;
                //NSLog(@"book image string:%@", picture);

                //facebook page of the image
                NSString *picturePage = item[@"link"];
                NSURL *mainPicPageURL = [NSURL URLWithString:picturePage];
                socBookMedia.mainPicPageURL = mainPicPageURL;

                //comments array under the picture
                NSArray *facebookComments = item[@"comments"];
                socBookMedia.faceboookCommentsArray = facebookComments;

                //Time
                NSString *createdAt = item[@"created"];
                NSLog(@"facebook time: %@", createdAt);

                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyy MM dd T HH:mm:ss Z"];
                NSDate *bookDate = [NSDate new];
                bookDate = [formatter dateFromString:createdAt];
                NSDate *nowDate = [NSDate date];
                NSDateFormatter *format = [NSDateFormatter new];
                [format setDateFormat:@"yyy MM dd T HH:mm:ss Z"];

                socBookMedia.timingDiff = [nowDate timeIntervalSinceDate:bookDate];

                if (socBookMedia.timingDiff < 1) {
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"now"];
                } else if (socBookMedia.timingDiff < 60){
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"%fs", socBookMedia.timingDiff];
                } else if (socBookMedia.timingDiff < 3600){
                    int diffRound = round(socBookMedia.timingDiff / 60);
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"%dm", diffRound];
                } else if (socBookMedia.timingDiff < 86400){
                    int diffRound = round(socBookMedia.timingDiff / 60 / 60);
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"%dh", diffRound];
                } else if (socBookMedia.timingDiff < 2629743){
                    int diffRound = round(socBookMedia.timingDiff / 60 / 60 / 24);
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"%dd", diffRound];
                } else if (socBookMedia.timingDiff < 18408201) {
                    int diffRound = round(socBookMedia.timingDiff / 60 / 60 / 24 / 7);
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"%dw", diffRound];
                } else{
                    socBookMedia.timeDiff = [NSString stringWithFormat:@"> a week"];
                }



                //  NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:item[@"created_at"] ascending:NO];
                //  NSArray *sortedArray = [NSArray arrayWithObject:sorter];
                //  NSLog(@"sorting... %@", sortedArray);
                
                [self.socialMediaArray addObject:socBookMedia];
                
                [self.tableView reloadData];
            }
        }
    }];
}


//these delegate methods will never fire, when using a URL connection with a completion block handler, need to use :https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html
//async using a custom delegateobject that uses at least: connection:didRecieveResponse, connection:didReicieveData, connection:didFailWithError, and: connection:didFinishLoading (all our found as methods inn..: NSURLConnectionDelegate, NSURLCOnnectionDownloadDelegate, and NSURLCOnnectionDataDelegate protocols)






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











