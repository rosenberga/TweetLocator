//
//  TTLakerTweetTableViewController.m
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import "TTLakerTweetTableViewController.h"

@implementation TTLakerTweetTableViewController
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.allTweets = [[NSMutableArray alloc] init];
    [self getTweets];
}

- (void) loadAllTweets {
    
    for(NSDictionary* tweet in self.objects) {
        @try {
            TTTweetObject* obj = [[TTTweetObject alloc] init];
            obj.point = [[MKPointAnnotation alloc]init];
            obj.status = tweet[@"text"];
            NSDictionary* user = tweet[@"user"];
            obj.userName = user[@"screen_name"];
            NSDictionary* geo = tweet[@"geo"];
            NSArray* coord = geo[@"coordinates"];
            NSString* lat = coord[0];
            NSString* lon = coord[1];
            obj.point.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            [self.allTweets addObject:obj];
        }
        @catch (NSException *exception) {
            NSLog(@"error");
        }
     }
}

- (void) getTweets {
    
    NSString* geo = [NSString stringWithFormat:@"%f,%f,%imi",self.point.coordinate.latitude,self.point.coordinate.longitude,(int)self.searchValue];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            if (accounts.count > 0)
            {
                self.twitterAccount = [accounts objectAtIndex:0];
                [accountStore saveAccount:self.twitterAccount withCompletionHandler:^(BOOL success, NSError *error) {
                    if(error) {
                        NSLog(@"error in saving account");
                    }
                }];
                [self getTweetsWithGeo:geo withTimes:1];
            }
        }
    }];
    if([accountStore accounts].count > 0) {
        self.twitterAccount = [accountStore accounts][0];
        [self getTweetsWithGeo:geo withTimes:self.reachedEnd];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Account Found"
                                                        message:@"Please connect your twitter account to this applicatio to retrieve data."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) getTweetsWithGeo:(NSString*) geo withTimes:(int) times {
    int sCount = 50;
    NSString* count = [NSString stringWithFormat:@"%i",sCount];
    NSLog(@"%@",count);
    
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary* params = @{@"count" : count,
                             @"screen_name" : self.twitterAccount.username,
                             @"q": self.searchText,
                             @"geocode" : geo};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url parameters:params];
    
    request.account = self.twitterAccount;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error) {
            NSLog(@"error in getting tweets");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"An error has occured in retrieving data. Please try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else {
            NSError *jsonError;
           NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            
            if(!jsonError) {
                 self.objects = data[@"statuses"];
                [self loadAllTweets];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"error");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"An error has occured in retrieving data. Please try again later."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTTweetTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    NSDictionary *tweet = self.objects[indexPath.row];
    cell.tweet.text = tweet[@"text"];
    NSDictionary* user = tweet[@"user"];
    
    cell.cover.image = [UIImage imageNamed:@"twitterlogo.png"];
    
    NSString* imageURL = user[@"profile_background_image_url"];
    if(imageURL != nil) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil ) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cover.image = [[UIImageView alloc] initWithImage:[UIImage imageWithData: data]].image;
            });
        });
    }
    NSString* at = @"@";
    NSString* userN = user[@"screen_name"];
    at = [at stringByAppendingString:userN];
    cell.user.text = at;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == (self.reachedEnd*25)-1) {
        self.reachedEnd = self.reachedEnd+1;
        [self getTweets];
    } else {
        NSLog(@"%zd %zd %zd",indexPath.row, self.objects.count, (self.reachedEnd*25)-1);
    }
}*/

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TTTweetMapView* view = [segue destinationViewController];
    view.allTweets = self.allTweets;
}

@end

