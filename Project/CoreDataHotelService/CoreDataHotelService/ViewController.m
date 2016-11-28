//
//  ViewController.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/28/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsVC.h"

#import "Hotel+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView {
    [super loadView];
    
    //assign background color of rootView
    [self.view setBackgroundColor:[UIColor grayColor]];
    //set title of nav bar
    [self.navigationItem setTitle:@"Hotel Manager"];
    
    [self setupCustomLayout];
}

-(void)setupCustomLayout {
    float navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    UIButton *browseButton = [self createButtonWithTitle:@"Browse" andBackgroundColor:[UIColor colorWithRed:1.0
                                                                                                      green:0.5
                                                                                                       blue:0.66
                                                                                                      alpha:1.0]];
    
    UIButton *bookButton = [self createButtonWithTitle:@"Book" andBackgroundColor:[UIColor colorWithRed:1.0
                                                                                                    green:0.1
                                                                                                    blue:0.66
                                                                                                    alpha:1.0]];
    
    UIButton *lookupButton = [self createButtonWithTitle:@"Lookup" andBackgroundColor:[UIColor colorWithRed:1.0
                                                                                                      green:0.3
                                                                                                       blue:0.4
                                                                                                      alpha:1.0]];
    
    [AutoLayout createLeadingConstraintFrom:browseButton
                                     toView:self.view];
    [AutoLayout createTrailingConstraintFrom:browseButton
                                     toView:self.view];
    
    NSLayoutConstraint *browseButtonTopConstraint = [AutoLayout createGenericConstraintFrom:browseButton
                                                                                     toView:self.view
                                                                              withAttribute:NSLayoutAttributeTop];
    browseButtonTopConstraint.constant = navigationBarHeight;
    
    [AutoLayout createLeadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:bookButton toView:self.view];
    
    NSLayoutConstraint *bookButtonCenterY = [AutoLayout createGenericConstraintFrom:bookButton
                                                                             toView:self.view
                                                                      withAttribute:NSLayoutAttributeCenterY];
    //bookButtonCenterY.constant = navigationBarHeight * 0.66; //center y offset
    
    [AutoLayout createLeadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:lookupButton toView:self.view];
    
    [AutoLayout createGenericConstraintFrom:lookupButton toView:self.view withAttribute:NSLayoutAttributeBottom];
    
    [AutoLayout createEqualHeightConstraintFrom:browseButton toView:self.view withMultiplier:0.66];
    
    [AutoLayout createEqualHeightConstraintFrom:lookupButton toView:self.view];
    [AutoLayout createEqualHeightConstraintFrom:browseButton toView:self.view];
    
    [browseButton addTarget:self
                     action:@selector(browseButtonSelected)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)browseButtonSelected:(UIButton *)sender {
    HotelsVC *hotelsVC = [[HotelsVC alloc]init];
    
    [self.navigationController pushViewController:hotelsVC animated:YES];
}

-(UIButton *)createButtonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)color {
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:button];
    
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
