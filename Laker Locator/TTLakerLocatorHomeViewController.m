//
//  TTLakerLocatorHomeViewController.m
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/10/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import "TTLakerLocatorHomeViewController.h"
@implementation TTLakerLocatorHomeViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if(self.point && self.searchText) {
        [self.searchButton setEnabled:YES];
    } else {
        [self.searchButton setEnabled:NO];
    }
    
    if(self.searchText) {
        self.searchPhrase.text = self.searchText;
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)composeTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#gvsu"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)longPress:(id)sender {
    UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer*) sender;
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (self.point) {
        [self.mapView removeAnnotation:self.point];
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.point = [[MKPointAnnotation alloc]init];
    self.point.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    self.point.title = @"";
    self.point.subtitle = @"";
    [self.mapView addAnnotation:self.point];
    [self setSearchButton];
}

- (void) setSearchButton {
    [self.searchButton setEnabled:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TTLakerTweetTableViewController* view = [segue destinationViewController];
    view.point = self.point;
    view.searchValue = self.slider.value;
    view.searchText = self.searchPhrase.text;
}
- (IBAction)sliderValueChanged:(id)sender {
    NSString* value = [NSString stringWithFormat:@"%i", (int) self.slider.value];
    self.sliderLabel.text = [value stringByAppendingString:@" miles"];
    self.slideValue = self.slider.value;
}
- (IBAction)searchPhraseEntered:(id)sender {
    if(self.searchPhrase.text.length <= 0) {
        [self.searchButton setEnabled:NO];
    } else {
        [self.searchButton setEnabled:YES];
        self.searchText = self.searchPhrase.text;
    }
}

@end
