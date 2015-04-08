//
//  TTTweetTableCell.h
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTweetTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UITextView *tweet;
@property (weak, nonatomic) IBOutlet UILabel *user;
@end
