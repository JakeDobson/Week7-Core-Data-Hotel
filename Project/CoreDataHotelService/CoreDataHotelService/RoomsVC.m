//
//  RoomsVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/29/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "RoomsVC.h"

#import "AutoLayout.h"

#import "AppDelegate.h"

#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"


@interface RoomsVC () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation RoomsVC

//-(void)loadView {
//    [super loadView];
//    
//    self.tableView = [[UITableView alloc]init];
//    
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    
//    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:@"cell"];
//    
//    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setTitle:@"Rooms"];
}

-(NSArray *)dataSource {
    if (!_dataSource) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
        
        NSError *fetchError;
        
        _dataSource = [context executeFetchRequest:request
                                             error:&fetchError];
        
        if (fetchError) {
            NSLog(@"Error Fetching Hotels from Core Data");
        }
    }
    return _dataSource;
}


//MARK: UITableView Required Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Hotel *hotel = self.dataSource[indexPath.row];
    cell.textLabel.text = hotel.hotelName;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


@end
