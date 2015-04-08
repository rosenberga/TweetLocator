//
//  TTTweetMapView.m
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import "TTTweetMapView.h"

@implementation TTTweetMapView
-(void) viewDidLoad {
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    for(TTTweetObject* obj in self.allTweets) {
        MKPointAnnotation* point = obj.point;
        NSString* at = @"@";
        point.title = [at stringByAppendingString:obj.userName];
        point.subtitle = obj.status;
        [self.mapView addAnnotation:point];
    }
}
-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        MKAnnotationView* pinView = nil;
        if([annotation isKindOfClass:[MKPointAnnotation class]]) {
            pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"customPin"];
            if(!pinView) {
                pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customPin"];
                pinView.canShowCallout = YES;
                pinView.image = [UIImage imageNamed:@"twitterlogosmall"];
            }
        }
        [mapView showAnnotations:mapView.annotations animated:YES];
        return pinView;
    }
}

@end
