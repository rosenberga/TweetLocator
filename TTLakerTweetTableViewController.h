//
//  TTLakerTweetTableViewController.h
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <CoreData/CoreData.h>
#import "TTTweetTableCell.h"
#import <Accounts/Accounts.h>
#import "TTTweetObject.h"
#import "TTTweetMapView.h"

@interface TTLakerTweetTableViewController : UITableViewController <UITableViewDelegate>
@property MKPointAnnotation* point;
@property float searchValue;
@property NSArray *objects;
@property ACAccount *twitterAccount;
@property NSMutableArray* allTweets;
@property NSString* searchText;
@property int reachedEnd;
@end
