
import UIKit


                        ////// CLASS 34 \\\\\\
                        ////// 12/01/16 \\\\\\



/*
 #NOTES:
 
 
 *** Versioning and Migrations ***
 --> anytime you make changes to your data model in production, you need to migrate

 - certain situations can avoid migrations all together.
    EX: if using core data as an offline cache, you can simply clear the old cache out and start new
 - when migration is needed, you need to create a new version of the data model, and provide a migration path

 ** Auto Migrations **
    - CD compares the store's model version w/coordinators model version
    - if versions don't match, CD will perform a migration(if endable)
    - when the migration process starts, CD looks at both
    - Under the Hood:
        -- copies all objects from old data stor
        -- connects all objects according to relationships
        -- enforces any data validation in the destination model
 
 *** iCloud and Core Data ***
 --> deprecated with iOS 10

 ---> a cloud service that gives your users a consistent and seamless experience across all of their iCloud-enabled devices
 
 - works w/ things called "ubiquity container" (lives in a shared space) which are special folders that your app uses to store data in the cloud (think dropbox)
 - whenever you make a change in your ubiquity container, the system uploads the changes to the cloud\
 - iCloud was closely integrated with CD to help persist your managed objects to the cloud
 
 - iOS 7 made enabling iCloud in your CD stack as simple as setting up your persisten store w/ a dict containing a few special options
 - NSPersistentStoreUbiquitousContentNameKey
 - NSPersistentStoreUbiquitousContentURLKey
 
 *** Analytics ***
 --> 
 
 -
 
 
 */
