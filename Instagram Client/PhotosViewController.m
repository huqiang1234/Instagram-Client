//
//  PhotosViewController.m
//  Instagram Client
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "PhotosViewController.h"
#import "MediaCell.h"
#import "UIIMageView+AFNetworking.h"
#import "PhotoDetailsViewController.h"
#import "HeaderView.h"


@interface PhotosViewController ()
@property (nonatomic, strong) NSArray *medias;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.mediaTableView insertSubview:self.refreshControl atIndex:0];

  self.mediaTableView.delegate = self;
  self.mediaTableView.dataSource = self;

  [self.mediaTableView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellReuseIdentifier:@"MediaCell"];
  [self.mediaTableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forCellReuseIdentifier:@"HeaderView"];

  self.mediaTableView.rowHeight = 320;


  NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=ed9f6ceacbc3476199174244f579e073"];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    // NSLog(@"response: %@", responseDictionary);
    self.medias = responseDictionary[@"data"];
    NSLog(@"media: %@", self.medias);
    [self.mediaTableView reloadData];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UIRefreshControl

- (void)onRefresh {
  NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=ed9f6ceacbc3476199174244f579e073"];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    // NSLog(@"response: %@", responseDictionary);
    self.medias = responseDictionary[@"data"];
    NSLog(@"media: %@", self.medias);
    [self.mediaTableView reloadData];
    [self.refreshControl endRefreshing];
  }];

}

# pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.medias.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  HeaderView *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderView"];

  NSInteger mediaIndex = section;
  NSDictionary *media = self.medias[mediaIndex];

  NSString *userName = [media valueForKeyPath:@"user.username"];
  cell.userNameLabel.text = userName;

  NSString *avatarUrlString = [media valueForKeyPath:@"user.profile_picture"];
  NSURL *url = [NSURL URLWithString:avatarUrlString];
  [cell.userAvatarImage setImageWithURL:url];


  return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 42.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger mediaIndex = indexPath.section;
  if(mediaIndex == self.medias.count - 1) {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=ed9f6ceacbc3476199174244f579e073"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      // NSLog(@"response: %@", responseDictionary);
      self.medias = responseDictionary[@"data"];
      NSLog(@"media: %@", self.medias);
      [self.mediaTableView reloadData];
    }];
  }

  MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaCell"];

  NSDictionary *media = self.medias[mediaIndex];
  NSString *urlString = [media valueForKeyPath:@"images.low_resolution.url"];
  NSURL *url = [NSURL URLWithString:urlString];
  [cell.mediaImageView setImageWithURL:url];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView  deselectRowAtIndexPath:indexPath animated:YES];
  PhotoDetailsViewController *vc = [[PhotoDetailsViewController alloc] init];
  vc.photo = self.medias[indexPath.section];
  [self.navigationController pushViewController:vc animated:true];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
