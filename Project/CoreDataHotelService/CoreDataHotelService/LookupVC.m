//
//  LookupVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/30/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "LookupVC.h"
#import "AutoLayout.h"
#import "Reservation+CoreDataClass.h"

@interface LookupVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UISearchBar *searchBar;
@property(strong, nonatomic)NSArray *reservations;

@end

@implementation LookupVC

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    
    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
//    UISearchController *searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Guests"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reservations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Reservation *reservation = self.reservations[indexPath.row];
    cell.textLabel.text = reservation.room;
    return cell;
}

@end
