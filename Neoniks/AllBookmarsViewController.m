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
@interface AllBookmarsViewController () <UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) NSArray *allBookmarks;
@property (strong, nonatomic) NSArray *chaptersDetails;

@end

@implementation AllBookmarsViewController


- (NSArray *)allBookmarks {
    if (!_allBookmarks) {
        _allBookmarks = [[BookmarksManager sharedManager] allBookmarks];
    }
    return _allBookmarks;
}


- (NSArray *)chaptersDetails {
    if (!_chaptersDetails) {
        NSURL *chaptersUrl = [NSURL urlFromName:@"chapters" extension:@"plist"];
        NSArray *tmpChapters = [[NSArray alloc] initWithContentsOfURL:chaptersUrl];
        NSMutableArray *tmpMutableChapters = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<tmpChapters.count; i++) {
            [tmpMutableChapters addObject:tmpChapters[i][@"pages"]];
        }
        
        _chaptersDetails = [NSArray arrayWithArray:tmpMutableChapters];
    }
    return _chaptersDetails;
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
    PageDetails *page = [self pageDetailsForNumber:pageNumber];
    NSString *string = [[NSString alloc] initWithFormat:@"Chapter: %d Page: %d", page.chapter, page.page];
    cell.textLabel.text = string;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageNumber = [self.allBookmarks[indexPath.row] integerValue];
    [self.delegate bookmarksRequiredToShow:pageNumber];
}


- (PageDetails *)pageDetailsForNumber:(NSInteger)number {
    NSInteger chapter = 0;
    NSInteger page = number;
    while ([self.chaptersDetails[chapter] integerValue] < page) {
        page -= [self.chaptersDetails[chapter] integerValue];
        chapter++;
    }
    PageDetails *pageDetail = [[PageDetails alloc] initWithPage:page chapter:chapter + 1];
    
    return pageDetail;
}

@end
