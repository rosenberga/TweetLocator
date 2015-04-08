//
//  TTLakerLocatorHomeViewController.h
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/10/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import "TTLakerTweetTableViewController.h"

@interface TTLakerLocatorHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *searchPhrase;
@property MKPointAnnotation* point;
@property float slideValue;
@property NSString* searchText;
@end
