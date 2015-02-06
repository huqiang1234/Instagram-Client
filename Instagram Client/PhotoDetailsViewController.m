//
//  PhotoDetailsViewController.m
//  Instagram Client
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "MediaCell.h"
#import "UIIMageView+AFNetworking.h"

@interface PhotoDetailsViewController ()

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.photoDetailTableView.delegate = self;
  self.photoDetailTableView.dataSource = self;

  [self.photoDetailTableView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellReuseIdentifier:@"MediaCell"];

  self.photoDetailTableView.rowHeight = 320;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaCell"];

  NSString *urlString = [self.photo valueForKeyPath:@"images.standard_resolution.url"];
  NSURL *url = [NSURL URLWithString:urlString];
  [cell.mediaImageView setImageWithURL:url];

  return cell;
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
