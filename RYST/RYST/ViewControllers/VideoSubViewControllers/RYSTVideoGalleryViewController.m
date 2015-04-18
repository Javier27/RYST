//
//  RYSTVideoGalleryViewController.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTVideoGalleryViewController.h"
#import "RYSTVideoCell.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface RYSTVideoGalleryViewController ()

@property (nonatomic, copy) NSArray *videoArray;

@end

@implementation RYSTVideoGalleryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    self.title = @"View Videos";
    _videoArray = [[NSArray alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.apiClient getVideos:@10 completion:^(NSArray *result, NSError *error) {
      weakSelf.videoArray = result;
      [weakSelf.tableView reloadData];
    }];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.tableView registerClass:[RYSTVideoCell class] forCellReuseIdentifier:CellIdentifier];
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
  [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews
{
  if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  }

  if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [self.videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  RYSTVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // implement video display technology here!
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

@end
