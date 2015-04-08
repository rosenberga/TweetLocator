//
//  TTTweetMapView.h
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TTTweetObject.h"

@interface TTTweetMapView : UIViewController <MKMapViewDelegate>
@property NSMutableArray* allTweets;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
