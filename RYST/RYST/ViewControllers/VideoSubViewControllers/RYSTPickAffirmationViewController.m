//
//  RYSTPickAffirmationViewController.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTPickAffirmationViewController.h"
#import "RYSTVideoViewController.h"
#import "RYSTAffirmationCell.h"
#import "RYSTAffirmation.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface RYSTPickAffirmationViewController ()

@property (nonatomic, copy) NSArray *affirmationArray;

@end

@implementation RYSTPickAffirmationViewController

- (id)initWithStyle:(UITableViewStyle)style
             parent:(RYSTVideoViewController *)parent
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    self.title = @"Pick Affirmation";
    _presenter = parent;
    _affirmationArray = [[NSArray alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.apiClient getAffirmations:@10 completion:^(NSArray *result, NSError *error) {
      weakSelf.affirmationArray = result;
      [weakSelf.tableView reloadData];
    }];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.tableView registerClass:[RYSTAffirmationCell class] forCellReuseIdentifier:CellIdentifier];
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
  return [self.affirmationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  RYSTAffirmationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }

  cell.affirmation = self.affirmationArray[indexPath.row];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.affirmationArray.count > indexPath.row) {
    [self.presenter dismissAffirmationTable:self.affirmationArray[indexPath.row]];
  } else {
    [self.presenter dismissAffirmationTable:nil];
  }
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
