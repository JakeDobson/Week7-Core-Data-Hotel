
import UIKit



                        ////// CLASS 33 \\\\\\
                        ////// 11/30/16 \\\\\\




/*
 #NOTES:
 
 
 *** Unit Testing ***
 --> software testing method by which individual units of source code are tested to determine whether they are fit to use

 - Swift and OBJC are both strongly and statically typed which helps avoid a lot of bugs, so unit testing is not really needed like it is in javascript
 - benefits...
    -- helps you design app during early stages
    -- test functionality of app's logic without having to rig up dummy UI or navigating apps screen
    -- TDD in a group setting can be beneficial, you know that if the tests break you know it's bad. Everyone on the same page that way
    ** XCTest **
        - test for every custom class in your app
        - inherits from XCTestCase
        - automatically have a setup() and teardown() methods
        - Test methods always return void, and start with a prefix "test" and takes in no parameters
        - each method can be run individually, or they all be run at the same time
            
        * First *
            - fast -- if your tests are slow, no one will run them
            - isolated -- should run properly when run by itself
            - repeatable -- should pass every time!
            - self-verifying -- reports success or failure
            - timely -- ideal to write tests before writing the code
    ** Structure of a Test **
        - Arrange -- all necessary preconditions and inputs
        - Act -- on the object or method under test
        - Assert -- expected results have occurred
    
    ** Writing Good Tests **
        - FIRST(Fast, Isolated, Repeatable, Self-verifying, Timely)
        - testing one unit of code
        - tests need to be isolated
        * What do I test? *
            - there are actually no rules
            - test all different paths of your app (if/switch/while loops, etc)
            - 3-5 tests for each public method
 
 
 *** TDD (Test-Driven Development) ***

 - test first -- write tests before code will be tested
 - red, green, refactor -- lifecycle of how to do TDD (fail, pass, refactor code)
 - setup() is called before each test method
    -- tearDown() is called after each test finishes
 
 
 *** NS Fetched Resutls Controller ***
 --> Efficiently manage the results returned from Core Data
 
 - initialize the fetch property with 4 parameters:
    -- request
    -- managed object context
    -- key path(optional)
    -- name of the cache(optional)
 
 - modes
    -- No tracking
    -- memory-only tracking
    -- Full-persistent tracking
 
 ** Workflow **
    - create fetch request
    - create fetched results controller
    - performFetch()
    - update UITableViewDataSource methods to query NSFetchedResultsController
 
 ** Section Grouping **
    - grouping your results is intuitive w/ the NSFetchedResultsController
    - 
 
 
 
 */
