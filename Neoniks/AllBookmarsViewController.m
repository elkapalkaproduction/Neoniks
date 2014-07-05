//
//  AllBookmarsViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AllBookmarsViewController.h"
#import "BookmarksManager.h"
#import "PageDetails.h"
#import "NSURL+Helps.h"
#import "ChaptersCollection.h"
#import "BookmarksTableViewCell.h"

@interface AllBookmarsViewController () <UITableViewDataSource, UITableViewDataSource, BookmarksCellInteraction>
@property (strong, nonatomic) NSArray *allBookmarks;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) ChaptersCollection *collection;

@end

@implementation AllBookmarsViewController

- (ChaptersCollection *)collection {
    if (!_collection) {
        _collection = [[ChaptersCollection alloc] init];
    }
    
    return _collection;
}


- (NSArray *)allBookmarks {
    if (!_allBookmarks) {
        _allBookmarks = [[BookmarksManager sharedManager] allBookmarks];
    }
    
    return _allBookmarks;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allBookmarks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookmarksTableViewCell *cell = (BookmarksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        NSString *nibName = NSStringFromClass([BookmarksTableViewCell class]);
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    NSInteger pageNumber = [self.allBookmarks[indexPath.row] integerValue];
    NSString *string = [[BookmarksManager sharedManager] nameStringForPage:pageNumber];
    cell.delegate = self;
    cell.textField.text = string;
    cell.pageNumber = pageNumber;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageNumber = [self.allBookmarks[indexPath.row] integerValue];
    [self.delegate bookmarksRequiredToShow:pageNumber];
}


- (void)removeBookmarkForCell:(BookmarksTableViewCell *)cell {
    [[BookmarksManager sharedManager] addOrRemoveBookmarkForPage:cell.pageNumber];
    self.allBookmarks = nil;
    [self.tableViewOutlet reloadData];
    [self.delegate updateBookmarkInfo];
}


- (void)startEditingForCell:(BookmarksTableViewCell *)cell {
    if (cell.textField.userInteractionEnabled) {
        cell.textField.borderStyle = UITextBorderStyleNone;
        cell.textField.userInteractionEnabled = NO;
        [cell.textField resignFirstResponder];
        NSString *value = cell.textField.text;
        [[BookmarksManager sharedManager] updateNameStringForPage:cell.pageNumber andName:value];
    } else {
        cell.textField.borderStyle = UITextBorderStyleRoundedRect;
        cell.textField.userInteractionEnabled = YES;
        [cell.textField becomeFirstResponder];
    }
}

@end
