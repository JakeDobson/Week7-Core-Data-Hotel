//
//  LookupVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/30/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "LookupVC.h"
#import "BookVC.h"


#import "AppDelegate.h"
#import "AutoLayout.h"

#import "Guest+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "Room+CoreDataClass.h"

@interface LookupVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UISearchBar *searchBar;
@property(strong, nonatomic)NSFetchedResultsController *currentReservations;
@property(strong, nonatomic)NSFetchRequest *reservationRequest;
@property(strong, nonatomic)NSManagedObjectContext *context;

@end

@implementation LookupVC

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupTableView];
    [self setupSearchBar];
    [self setupFetchRequestAndContext];
    [self setTitle:@"Guests"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void)setupTableView {
    self.tableView = [[UITableView alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    
    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
}

-(void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc]init];
    
    self.searchBar.delegate = self;
    
    self.searchBar.placeholder = @"enter your email...";
    
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.searchBar];
    
    [self.searchBar becomeFirstResponder];
    
    //constraints
    [AutoLayout createLeadingConstraintFrom:self.view toView:self.searchBar];
    [AutoLayout createTrailingConstraintFrom:self.view toView:self.searchBar];
    
    NSLayoutConstraint *topConstraint = [AutoLayout createGenericConstraintFrom:self.searchBar
                                                                         toView:self.view
                                                                  withAttribute:NSLayoutAttributeTop];
    topConstraint.constant = 64.0;

}

-(void)setupFetchRequestAndContext {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.context = appDelegate.persistentContainer.viewContext;
    
    self.reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    self.reservationRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"room.hotel.hotelName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"room.roomNumber" ascending:YES] ];
}

-(NSFetchedResultsController *)currentReservations {
    if (![self.searchBar.text  isEqualToString:@""]) {
        self.reservationRequest.predicate = [NSPredicate predicateWithFormat:@"guest.email == %@", self.searchBar.text];
        if (!_currentReservations) {
            _currentReservations = [[NSFetchedResultsController alloc]initWithFetchRequest:self.reservationRequest managedObjectContext:self.context sectionNameKeyPath:@"guest.email" cacheName:nil];
        } else {
            _currentReservations.fetchRequest.predicate = self.reservationRequest.predicate;
        }
        NSError *requestError;
        [_currentReservations performFetch:&requestError];
        
        if (requestError) {
            NSLog(@"There was an error requestiing available rooms");
            return nil;
        }
    }
    return _currentReservations;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    Reservation *reservation = [self.currentReservations objectAtIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i\n%@ through %@", reservation.room.roomNumber, [dateFormatter stringFromDate:reservation.startDate], [dateFormatter stringFromDate:reservation.endDate]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.currentReservations sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.currentReservations.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.currentReservations sections]objectAtIndex:section];
    Reservation *reservation = [[sectionInfo objects]objectAtIndex:section];
    return [NSString stringWithFormat:@"%@ Reservation", reservation.room.hotel.hotelName];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchBar.text) {
        [self.tableView reloadData];
    }
}


@end
