//
//  TTTweetTableCell.m
//  Laker Locator
//
//  Created by Adam Rosenberg on 12/11/14.
//  Copyright (c) 2014 TransientTurtle. All rights reserved.
//

#import "TTTweetTableCell.h"

@implementation TTTweetTableCell
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
@end
