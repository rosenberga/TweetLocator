//
//  TTTweetObject.h
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TTTweetObject : NSObject
@property NSString* userName;
@property NSString* status;
@property MKPointAnnotation* point;
@end
