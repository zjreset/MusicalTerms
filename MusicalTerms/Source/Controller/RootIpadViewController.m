//
//  RootIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootIpadViewController.h"
#import "SearchIpadViewController.h"
#import "ClassfyIpadViewController.h"
#import "SpeedIpadViewController.h"
#import "HistoryIpadViewController.h"
#import "DataBase.h"

@interface RootIpadViewController ()

@end

@implementation RootIpadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self){
        NSMutableArray *tabArray = [NSMutableArray array]; 
        
        SearchIpadViewController *view1 = [[SearchIpadViewController alloc] initWithNibName:@"SearchIpadViewController" bundle:[NSBundle mainBundle]];
        ClassfyIpadViewController *view2 = [[ClassfyIpadViewController alloc] initWithNibName:@"ClassfyIpadViewController" bundle:[NSBundle mainBundle]];
        SpeedIpadViewController *view3 = [[SpeedIpadViewController alloc] initWithNibName:@"SpeedIpadViewController" bundle:[NSBundle mainBundle]];
        HistoryIpadViewController *view4 = [[HistoryIpadViewController alloc] initWithNibName:@"HistoryIpadViewController" bundle:[NSBundle mainBundle]];
        
        //加载数据库控制器
        DataBase *db =[[DataBase alloc]init];
        view2.listContent = view1.listContent = [db quaryTable:nil type:0];
        view3.listContent = [db quaryTable:nil type:4];
        [db release];
        
        [tabArray addObject:view1.splitViewController];
        [tabArray addObject:view2.splitViewController];
        [tabArray addObject:view3.splitViewController];
        [tabArray addObject:view4.splitViewController];
        
        [view1 release];
        [view2 release];
        [view3 release];
        [view4 release];
        
        self.viewControllers = tabArray;
        //self.view = view1.splitViewController.view;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeDb];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//IOS6 支持
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
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
    //[self.view removeFromSuperview];
    //[delegate getMain];
    return YES;
}

@end
