//
//  LookupVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/30/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import <Flurry.h>

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
    
    [self setupSearchBarAndTableView];
    [self setupFetchRequestAndContext];
    [self setTitle:@"Guests"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Flurry logEvent:@"Timed_User_Search" timed:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void)setupSearchBarAndTableView {
    //searchBar
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"enter your email...";
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.searchBar];
    
    //constraints
    [AutoLayout createLeadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.searchBar toView:self.view];
    
    NSLayoutConstraint *topConstraint = [AutoLayout createGenericConstraintFrom:self.searchBar
                                                                         toView:self.view
                                                                  withAttribute:NSLayoutAttributeTop];
    topConstraint.constant = 64.0;
    
    //tableView
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    
    //constraints
    [AutoLayout createLeadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.tableView toView:self.view];
    
    NSLayoutConstraint *tableViewTop = [AutoLayout createGenericConstraintFrom:self.tableView toView:self.searchBar withAttribute:NSLayoutAttributeTop];
    tableViewTop.constant = 44.0;//CGRectGetHeight(self.searchBar.frame);
    
    [AutoLayout createGenericConstraintFrom:self.tableView toView:self.view withAttribute:NSLayoutAttributeBottom];
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
    [self.searchBar becomeFirstResponder];
    
    if (self.searchBar.text) {
        [Flurry logEvent:@"User_Searched_Reservations"];
        [Flurry logEvent:@"Timed_User_Search" withParameters:nil];
        [self.tableView reloadData];
    }
    [self.searchBar resignFirstResponder];
}


@end
