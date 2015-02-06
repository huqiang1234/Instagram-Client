//
//  PhotoDetailsViewController.h
//  Instagram Client
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *photo;
@property (weak, nonatomic) IBOutlet UITableView *photoDetailTableView;

@end
