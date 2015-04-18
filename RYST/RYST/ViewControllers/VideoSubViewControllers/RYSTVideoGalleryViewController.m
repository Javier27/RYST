//
//  RYSTVideoGalleryViewController.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "RYSTVideoGalleryViewController.h"
#import "RYSTVideoCell.h"
#import "RYSTVideo.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface RYSTVideoGalleryViewController ()

@property (nonatomic, copy) NSArray *videoArray;

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
    [self.apiClient getVideos:@10 completion:^(NSArray *result, NSError *error) {
      [weakSelf finishFormOperation];
      weakSelf.videoArray = result;
      [weakSelf.tableView reloadData];
    }];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];
    headerView.backgroundColor = [UIColor lightGrayColor];

    UIButton *backButtonContainer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButtonContainer addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 24)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButtonContainer addSubview:backButton];

    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = NSLocalizedString(@"View Videos", nil);
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

@end
