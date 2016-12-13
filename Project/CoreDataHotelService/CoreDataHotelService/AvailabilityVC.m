//
//  AvailabilityVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/29/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "AvailabilityVC.h"
#import "BookVC.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Reservation+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"

@interface AvailabilityVC () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *availabilityTableView;
@property(strong, nonatomic) NSFetchedResultsController *availableRooms; //dataSource as a backing array, not for the tableView

@end

@implementation AvailabilityVC

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
    [self setTitle:@"Available Rooms"];
}

-(void)viewDidLoad {
    [super viewDidLoad];

}

-(NSFetchedResultsController *)availableRooms {
    //creating lazy property...
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate >= %@", self.startDate, [NSDate date]];
        NSString *requestDomain = @"request";
        NSInteger requestErrorCode = 303;
        NSDictionary *requestDict = @{@"requested" : @"Error with fetch request"};
        NSError *requestError = [NSError errorWithDomain:requestDomain code:requestErrorCode userInfo:requestDict];
        
        NSArray *results = [context executeFetchRequest:request error:&requestError];
        
        if (requestError) {
            NSLog(@"%@", requestError);
            return nil;
        }
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms]; // determines what data is now in the data set
        roomRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hotel.hotelName" ascending:YES]]; //how data is sorted
        
        NSError *roomRequestError;
        
        _availableRooms = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:context sectionNameKeyPath:@"hotel.hotelName" cacheName:nil];
        [_availableRooms performFetch:&roomRequestError];
        
        if (roomRequestError) {
            NSLog(@"There was an error requesting available rooms");
        }
    }
    return _availableRooms;
}

-(void)setupTableView {
    self.availabilityTableView = [[UITableView alloc]init];
    self.availabilityTableView.dataSource = self;
    self.availabilityTableView.delegate = self;
    self.availabilityTableView.translatesAutoresizingMaskIntoConstraints = NO; //has to be before the subview
    
    [self.view addSubview:self.availabilityTableView];
    
    [self.availabilityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.availabilityTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                        forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Room *room = [self.availableRooms objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i(%i beds, $%.2f)",   room.roomNumber,
                                                                                    room.beds,
                                                                                    room.rate.floatValue];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sections = [self.availableRooms sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *sections = [self.availableRooms sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    Room *room = [[sectionInfo objects] objectAtIndex:section];
    
    return room.hotel.hotelName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Room *room = [self.availableRooms objectAtIndexPath:indexPath];
    
    BookVC *bookVC = [[BookVC alloc]init];
    bookVC.room = room;
    bookVC.endDate = self.endDate;
    //bookVC.startDate = self.startDate;
    
    [self.navigationController pushViewController:bookVC animated:YES];
}

@end
