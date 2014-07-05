//
//  BookmarksTableViewCell.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 7/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookmarksTableViewCell.h"

@implementation BookmarksTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)editButton:(id)sender {
    [self.delegate startEditingForCell:self];
}


- (IBAction)remove:(id)sender {
    [self.delegate removeBookmarkForCell:self];
}

@end
