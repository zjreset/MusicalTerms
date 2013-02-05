//
//  SpeedIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpeedIpadViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "MyDetailView.h"

@interface SpeedIpadViewController ()

@end

@implementation SpeedIpadViewController
@synthesize listContent,player;
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
        splitViewController = [[UISplitViewController alloc] initWithNibName:@"SpeedIpadViewController" bundle:nil];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"速度词汇" image:[UIImage imageNamed:@"icon_star.png"] tag:3];
        splitViewController.tabBarItem = tabBarItem;
        [tabBarItem release];
        splitViewController.delegate = self;
        detailViewController = [[DetailNavigationViewController alloc] initWithNibName:@"DetailNavigationViewController" bundle:nil];
        splitViewController.viewControllers = [[NSArray alloc] initWithObjects:[[[UINavigationController alloc] initWithRootViewController:self] autorelease], detailViewController, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置标题
	self.title = @"速度词汇";
	self.tableView.scrollEnabled = YES;
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
    return [self.listContent count];
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
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];
    
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
    if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
        cell.imageView.image = [UIImage imageNamed:@"icon_annoucement.png"];
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.imageName = musicInfo.ws_name;     //将文件名称传入图片属性中,待点击时获取文件
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
    //[cell.translationLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    NSMutableString *msg = [[NSMutableString alloc] init];
    if(musicInfo.ws_simple_bpm != NULL){
        [msg appendString:[NSString stringWithFormat:@"【BPM参考值】:%@",musicInfo.ws_simple_bpm]];
    }
    if(musicInfo.ws_area_bpm != NULL){
        [msg appendString:[NSString stringWithFormat:@"【BPM范围值】:%@",musicInfo.ws_area_bpm]];
    }
    cell.translationLabel.text = msg;
    [msg release];
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];    
    detailViewController.title = musicInfo.wi_name;
    
    //记录访问历史
    DataBase *db = [[DataBase alloc] init];
    [db saveHistory:musicInfo.wi_id type:1];
    [db release];
    
    UIViewController *scrollViewController = [[UIViewController alloc] init];
    scrollViewController.title = musicInfo.wi_name;
    MyDetailView *myDetailView = [[MyDetailView alloc] init];
    [myDetailView setDetailsView:musicInfo withType:3];
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


/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[player release];
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

@end
