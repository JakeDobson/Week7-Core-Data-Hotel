//
//  ViewController.m
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/28/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import "ViewController.h"
#import "Hotel+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView {
    [super loadView];
    
    //assign background color of rootView
    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
