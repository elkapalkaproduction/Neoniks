//
//  BookmarksTableViewCell.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 7/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookmarksTableViewCell;

@protocol BookmarksCellInteraction
- (void)removeBookmarkForCell:(BookmarksTableViewCell *)cell;
- (void)startEditingForCell:(BookmarksTableViewCell *)cell;

@end

@interface BookmarksTableViewCell : UITableViewCell
@property (weak, nonatomic) id <BookmarksCellInteraction> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (assign, nonatomic) NSInteger pageNumber;

@end
