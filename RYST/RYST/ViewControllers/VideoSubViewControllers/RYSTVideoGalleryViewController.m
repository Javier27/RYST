//
//  RYSTVideoGalleryViewController.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "RYSTAffirmationFilterView.h"
#import "RYSTAffirmation.h"
#import "RYSTVideoGalleryViewController.h"
#import "RYSTVideoCell.h"
#import "RYSTVideo.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface RYSTVideoGalleryViewController () <RYSTAffirmationFilterViewDelegate>

@property (nonatomic, copy) NSArray *affirmationArray;
@property (nonatomic, copy) NSArray *videoArray;
@property (nonatomic, copy) NSNumber *filterIdentifier;
@property (nonatomic, strong) RYSTAffirmationFilterView *filterView;

@end

@implementation RYSTVideoGalleryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    _videoArray = [[NSArray alloc] init];

    __weak typeof(self) weakSelf = self;
    [weakSelf beginFormOperationWithActivityCaption:NSLocalizedString(@"Loading Videos...", nil)
                                              alpha:1.0f];
    [self.apiClient getVideos:nil completion:^(NSArray *result, NSError *error) {
      [weakSelf finishFormOperation];
      weakSelf.videoArray = result;

      NSMutableArray *affirmationArray = [[NSMutableArray alloc] init];
      NSMutableArray *affirmationIds = [[NSMutableArray alloc] init];
      for (RYSTVideo *video in result) {
        if (![affirmationIds containsObject:video.affirmation.affirmationIdentifier]) {
          [affirmationIds addObject:video.affirmation.affirmationIdentifier];
          [affirmationArray addObject:video.affirmation];
        }
      }
      _affirmationArray = affirmationArray;

      [weakSelf.tableView reloadData];
    }];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60.0f)];
    headerView.backgroundColor = [UIColor lightGrayColor];

    UIButton *backButtonContainer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    [backButtonContainer addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 25, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButtonContainer addSubview:backButton];

    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 70,
                                                                        10,
                                                                        60,
                                                                        35)];
    filterButton.backgroundColor = [UIColor lightGrayColor];
    [filterButton setTitle:NSLocalizedString(@"filter", nil) forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0f];
    filterButton.layer.cornerRadius = 2.0f;
    filterButton.layer.borderWidth = 1.0f;
    filterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [filterButton addTarget:self action:@selector(pickFilter) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:filterButton];

    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = NSLocalizedString(@"Videos", nil);
    headerLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0f];
    headerLabel.textColor = [UIColor blackColor];
    [headerLabel sizeToFit];
    headerLabel.center = headerView.center;
    [headerView addSubview:headerLabel];

    [headerView addSubview:backButtonContainer];
    self.tableView.tableHeaderView = headerView;
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

  cell.video = self.videoArray[indexPath.row];

  if (indexPath.row % 2 == 0) {
    cell.backgroundColor = [UIColor colorWithRed:(253.0/255.0) green:(168.0/255.0) blue:(171.0/255.0) alpha:1.0];
  } else {
    cell.backgroundColor = [UIColor colorWithRed:(211.0/255.0) green:(105.0/255.0) blue:(108.0/255.0) alpha:1.0];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RYSTVideo *video = self.videoArray[indexPath.row];
  NSURL *videoURL = [NSURL URLWithString:video.url];
  MPMoviePlayerViewController *viewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
  [self presentMoviePlayerViewControllerAnimated:viewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

- (void)goBack
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickFilter
{
  RYSTAffirmationFilterView *filterView = [[RYSTAffirmationFilterView alloc] initWithFrame:self.view.bounds affirmations:self.affirmationArray];
  filterView.delegate = self;
  self.filterView = filterView;
  [self.view addSubview:filterView];
}

- (void)affirmationSelected:(RYSTAffirmation *)affirmation shouldUpdate:(BOOL)shouldUpdate
{
  if (shouldUpdate) {
    self.filterIdentifier = affirmation.affirmationIdentifier;

    __weak typeof(self) weakSelf = self;
    [weakSelf beginFormOperationWithActivityCaption:NSLocalizedString(@"Loading Videos...", nil)
                                              alpha:1.0f];
    [self.apiClient getVideos:self.filterIdentifier completion:^(NSArray *result, NSError *error) {
      [weakSelf finishFormOperation];
      weakSelf.videoArray = result;
      [weakSelf.tableView reloadData];
    }];
  }

  [self.filterView removeFromSuperview];
  self.filterView = nil;
}

@end
