//
//  HistoryIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryIpadViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "MyDetailView.h"

@interface HistoryIpadViewController ()

@end

@implementation HistoryIpadViewController
@synthesize listContent,player,noResultToDisplay,deleteButton;
@synthesize popoverController, splitViewController, rootPopoverButtonItem,detailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        splitViewController = [[UISplitViewController alloc] initWithNibName:@"HistoryIpadViewController" bundle:nil];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"最近访问" image:[UIImage imageNamed:@"icon_time.png"] tag:4];
        splitViewController.tabBarItem = tabBarItem;
        [tabBarItem release];
        self.splitViewController.delegate = self;
        detailViewController = [[DetailNavigationViewController alloc] initWithNibName:@"DetailNavigationViewController" bundle:nil];
        splitViewController.viewControllers = [[NSArray alloc] initWithObjects:[[[UINavigationController alloc] initWithRootViewController:self] autorelease], detailViewController, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
    [super viewDidLoad];
    //设置标题
	self.title = @"最近访问";
    noResultToDisplay = TRUE;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.scrollEnabled = YES;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 106, 44)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] 
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                          target:nil 
                                          action:nil];
    [buttons addObject:flexibleSpaceLeft];
    [flexibleSpaceLeft release];
    
    deleteButton = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                    target:self
                    action:@selector(deleteAction:)];
    deleteButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:deleteButton];
    
    [toolbar setItems:buttons animated:NO];
    toolbar.barStyle = -1;
    [buttons release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
    [toolbar release];
}

- (void)viewWillAppear:(BOOL)animated
{
    DataBase *db = [[DataBase alloc] init];
    self.listContent = [db quaryTable:nil type:3];
    [db release];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.splitViewController = nil;
	self.rootPopoverButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"检索列表";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.listContent count] == 0) {
        noResultToDisplay = TRUE;
    }
    else {
        noResultToDisplay = FALSE;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
    if (noResultToDisplay) {
        return 1;
    }
    else {
        return [self.listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        //使用自定义的模板
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
	}
    
    if(noResultToDisplay){
        cell.nameLabel.text = @"当前还没有访问的历史信息";
        cell.translationLabel.text = nil;
    }
    else {
        MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];
        
        NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
        if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
            cell.imageView.image = [UIImage imageNamed:@"icon_annoucement.png"];
            cell.imageView.userInteractionEnabled = YES;
            cell.imageView.imageName = musicInfo.wi_name;     //将文件名称传入图片属性中,待点击时获取文件
            UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakVoice:)];
            singleTouch.numberOfTouchesRequired = 1;    //触摸点个数
            singleTouch.numberOfTapsRequired = 1;
            [cell.imageView addGestureRecognizer:singleTouch];
            [singleTouch release];
            musicFilePath = nil;
        }
        if(musicInfo.wi_language != NULL){
            cell.nameLabel.text = [musicInfo.wi_name stringByAppendingString: musicInfo.wi_language];
        }
        else{
            cell.nameLabel.text = musicInfo.wi_name;
        }
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        if(musicInfo.wi_translation_simple != NULL){
            cell.translationLabel.text = musicInfo.wi_translation_simple;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!noResultToDisplay) {
        MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];    
        detailViewController.title = musicInfo.wi_name;
        
        UIViewController *scrollViewController = [[UIViewController alloc] init];
        scrollViewController.title = musicInfo.wi_name;
        MyDetailView *myDetailView = [[MyDetailView alloc] init];
        [myDetailView setDetailsView:musicInfo withType:4];
        scrollViewController.view = myDetailView;
        [myDetailView release];
        NSMutableArray *itemsArray = [detailViewController.navigationBar.topItem.rightBarButtonItems mutableCopy];
        [detailViewController pushViewController:scrollViewController animated:YES];
        [scrollViewController release];
        if (itemsArray != nil && itemsArray.count > 0) {
            [detailViewController.navigationBar.topItem setRightBarButtonItems:itemsArray animated:NO];
        }
        [itemsArray release];
    }
}


/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[player release];
    [deleteButton release];
    [popoverController release];
    [rootPopoverButtonItem release];
    [detailViewController release];
    [splitViewController release];
	[super dealloc];
}

#pragma mark - slef method
/**
 * 点击图标播放声音
 */
- (void)speakVoice:(UITapGestureRecognizer *)sender
{ 
    
    if(sender.state == UIGestureRecognizerStateEnded)
    { 
        NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[((SpeakImageView*)sender.view).imageName lowercaseString] ofType:@"mp3"];       //创建音乐文件路径
        if (musicFilePath != NULL) {
            NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];  
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            
            [musicURL release];
            //[player prepareToPlay];
            if (player == nil){
                NSLog(@"audio player not initialized");   
            }          
            else if(TARGET_IPHONE_SIMULATOR){
                NSLog(@"player play"); 
                //[player play];   //播放
            } 
            else{
                [player play];  
            }
        }
        
    }
}

/**
 * 通过按钮点击响应超链接的页面跳转
 */
- (void)showWebView:(UITapGestureRecognizer *)sender
{
    MyLabel *wi_link_path = (MyLabel*)sender.view;
    UIViewController *webController = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:wi_link_path.text]];
    [webView loadRequest:request];
    webController.view = webView;
    NSMutableArray *itemsArray = [detailViewController.navigationBar.topItem.rightBarButtonItems mutableCopy];
    [detailViewController pushViewController:webController animated:YES];
    if (itemsArray != nil && itemsArray.count > 0) {
        [detailViewController.navigationBar.topItem setRightBarButtonItems:itemsArray animated:NO];
    }
    [itemsArray release];
    [webView release];
    [webController release];
}

/**
 * 清空历史访问记录
 */
- (void)deleteAction:(id)sender
{
    DataBase *db =[[DataBase alloc]init];
    [db deleteHistoryTable];
    [db release];
    self.listContent = nil;
    [self.tableView reloadData];
}

@end
