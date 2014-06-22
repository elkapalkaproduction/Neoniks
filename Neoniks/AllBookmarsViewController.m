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

@interface AllBookmarsViewController () <UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) NSArray *allBookmarks;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSInteger pageNumber = [self.allBookmarks[indexPath.row] integerValue];
    PageDetails *page = [self.collection pageDetailsForNumber:pageNumber];
    NSString *string = [[NSString alloc] initWithFormat:@"Chapter: %d Page: %d", page.chapter, page.page];
    cell.textLabel.text = string;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageNumber = [self.allBookmarks[indexPath.row] integerValue];
    [self.delegate bookmarksRequiredToShow:pageNumber];
}

@end
