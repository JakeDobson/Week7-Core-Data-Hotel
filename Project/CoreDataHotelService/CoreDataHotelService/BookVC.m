//
//  BookVC.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/29/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "BookVC.h"
#import "AutoLayout.h"
#import "AppDelegate.h" //will be saving to the Core Data context...
#import "Room+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "Guest+CoreDataClass.h"

@interface BookVC ()

@property(strong, nonatomic) UITextField *nameField;
// create 2 more prop text fields

@end

@implementation BookVC

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupMessageLabel];
    [self setupNameTextField];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                            target:self
                                                                                            action:@selector(saveButtonSelected:)]];
}

-(void)viewDidLoad {
    [super viewDidLoad];

}

-(void)setupMessageLabel {
    UILabel *messageLabel = [[UILabel alloc]init];
    
    messageLabel.textAlignment = NSTextAlignmentCenter; //give text alignment of center by assigning from enum
    messageLabel.numberOfLines = 0; //so text will not get truncated
    
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:messageLabel];
    
    CGFloat myMargin = 20.0;
    
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:messageLabel toView:self.view];
    leading.constant = myMargin;
    
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:messageLabel toView:self.view];
    trailing.constant = -myMargin;
    
    [AutoLayout createGenericConstraintFrom:messageLabel
                                     toView:self.view
                              withAttribute:NSLayoutAttributeCenterY];
    messageLabel.text = [NSString stringWithFormat:@"Reservation At:%@\nRoom:%i\nFrom:Today - %@", self.room.hotel.hotelName, self.room.roomNumber, self.endDate];//dont forget to add self.startDate for hw
}

-(void)setupNameTextField {
    self.nameField = [[UITextField alloc]init];
    
    self.nameField.placeholder = @"Please enter your name...";
    
    [self.nameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.nameField];
    
    CGFloat myMargin = 20.0;
    CGFloat navAndStatusBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20.0; // 20.0 for status bar
    
    NSLayoutConstraint *top = [AutoLayout createGenericConstraintFrom:self.nameField toView:self.view withAttribute:NSLayoutAttributeTop];
    top.constant = navAndStatusBarHeight + myMargin;;
    
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:self.nameField toView:self.view];
    leading.constant = myMargin;
    
    NSLayoutConstraint *trailing = [AutoLayout createLeadingConstraintFrom:self.nameField toView:self.view];
    trailing.constant = myMargin;
    
    [self.nameField becomeFirstResponder]; //pulls up the keyboard when clicked on
}

//what to do when they click on the save button
-(void)saveButtonSelected:(UIBarButtonItem *)sender {
    
    // if self.textField is empty...do not create reservation! -- error handling here..
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate]; // delegate is id, so cast into AppDelegate
    
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservaton" inManagedObjectContext:context];
    
    reservation.startDate = [NSDate date];
    reservation.endDate = self.endDate;
    reservation.room = self.room;
    
    self.room.reservations = [self.room.reservations setByAddingObject:reservation]; //adds reservation to that set and replaces the new on (calulate what's on right and reassinging it back into itself) "pointer manipulation"
    
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    reservation.guest.name = self.nameField.text;
    
    NSError *saveError;
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"There was an error saving new reservation");
    } else {
        NSLog(@"Saved Reservation Successfully!");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
