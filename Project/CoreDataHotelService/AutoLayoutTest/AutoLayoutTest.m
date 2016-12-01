//
//  AutoLayoutTest.m
//  AutoLayoutTest
//
//  Created by Jacob Dobson on 11/30/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTest : XCTestCase

@property(strong, nonatomic)UIViewController *testController;
@property(strong, nonatomic)UIView *testView1;
@property(strong, nonatomic)UIView *testView2;

@end

@implementation AutoLayoutTest

- (void)setUp {
    [super setUp];
    
    self.testController = [[UIViewController alloc]init];
    self.testView1 = [[UIView alloc]init];
    self.testView2 = [[UIView alloc]init];
    //self.testView2 = self.testView1; //will not work, but showing that it will fail!
    
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
}

- (void)tearDown {
    self.testController = nil;
    self.testView1 = nil;
    self.testView2 = nil;
    
    [super tearDown];
}

-(void)testViewControllerNotNil {
    XCTAssertNotNil(self.testController, @"self.controller is nil!"); //string we will see if it fails the test
}

-(void)testViewsAreNotEqual {
    XCTAssertNotEqual(self.testView1, self.testView2, @"testView1 is equal to testView2");
}

-(void)testViewClass {
    XCTAssert([self.testView1 isKindOfClass:[UIView class]], @"view1 is not a UIView!");
}

-(void)testCreateGenericConstraintFromViewToViewWithAttributeAndMultiplier {
    id constraint = [AutoLayout createEqualHeightConstraintFrom:self.testView1 toView:self.testView2 withMultiplier:NSLayoutAttributeTop];
    
    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]], @"constraint is NOT a NSLayoutConstraint object");
}

-(void)testActivateFullViewConstraintsReturnsConstraintsArray {
    NSArray *constraints = [AutoLayout activateFullViewConstraintsUsingVFLFor:self.testView1];
    
    int count = 0;
    
    for (id constraint in constraints) {
        if (![constraint isKindOfClass:[NSLayoutConstraint class]]) {
            count++;
        }
    }
    XCTAssert(count == 0, @"Array contains %i objects that are not NSLayout constraints", count);
}

//-(void)

//-(void)
//
//
//-(void)
//
//
//-(void)
//
//
//-(void)

    
@end
