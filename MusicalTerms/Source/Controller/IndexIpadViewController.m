//
//  IndexIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IndexIpadViewController.h"

@interface IndexIpadViewController ()

@end

@implementation IndexIpadViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeDb];
    //[self performSelector:@selector(initializeDb) withObject:nil afterDelay:0];
}

- (BOOL) initializeDb {  
    NSLog (@"初始化DB");  
    // look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)  
    //START:code.DatabaseShoppingList.findDocumentsDirectory  
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];  
    //查看文件目录  
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"music_db.db"];
    //END:code.DatabaseShoppingList.findDocumentsDirectory  
    //START:code.DatabaseShoppingList.copyDatabaseFileToDocuments  
    if (![[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:dbFilePath error:nil];
        // didn't find db, need to copy  
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"music_db" ofType:@"db"];
        NSLog(@"%@",backupDbPath);
        if (backupDbPath == nil) {  
            // couldn't find backup db to copy, bail  
            return NO;  
        } else {  
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];  
            if (! copiedBackupDb) {  
                // copying backup db failed, bail  
                return NO;  
            }  
        }  
    }
    NSLog (@"完成初始化DB");  
    [self.view removeFromSuperview];
    [delegate getMain];
    return YES;  
}  

@end
