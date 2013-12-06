//
//  TweetViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "TweetViewController.h"
#import "DataParser.h"
#import "User.h"
#import "ODRefreshControl.h"
#import "TweetCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlaceholderView.h"

@interface TweetViewController ()
@property (strong,nonatomic) NSArray *tweets;
@property (strong,nonatomic) PlaceholderView *placeholder;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    self.tweets = nil;
    ODRefreshControl *r = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    r.tintColor = [UIColor blackColor];
    [r addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    [self loadData:nil];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void) loadData:(ODRefreshControl *)r{
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"alerts/getTweets"]
                   usingParameters:@{@"city_id":[[DataParser sharedInstance] getUser].city_id}
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       if(r != nil) [r endRefreshing];
                       [[CBProgressPanel sharedInstance] hide];
                       NSError *errorJson = nil;
                       NSDictionary *dic= [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:0
                                          error:&errorJson];
                       if([[dic objectForKey:@"success"] boolValue]){
                           self.tweets = [dic objectForKey:@"data"];
                           [self.tableView reloadData];
                       }
                   }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *d = [self.tweets objectAtIndex:indexPath.row];
    NSString *user = NULL_TO_NIL([d objectForKey:@"rt_user"]);
    if(user != nil){
        [cell.avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/api/users/profile_image?size=bigger&screen_name=%@",user]]
                       placeholderImage:[UIImage imageNamed:@"tweet-icon-placeholder"]];
        
    }
    cell.tweet.text = [d objectForKey:@"text"];
    cell.created.text = [d objectForKey:@"date"];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [self.tweets count];
    if(count == 0){
        self.placeholder = [[PlaceholderView alloc] initWithTitle:NSLocalizedString(@"There are no alerts to display.", @"") andSubtitle:nil withFrame:self.tableView.frame textColor:[UIColor blackColor]];
        [self.tableView addSubview:self.placeholder];
    }else{
        [self.placeholder removeFromSuperview];
    }
    

    
    return count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
