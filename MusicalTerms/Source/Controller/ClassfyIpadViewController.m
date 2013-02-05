//
//  ClassfyIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClassfyIpadViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "MyDetailView.h"

@interface ClassfyIpadViewController ()

@end

@implementation ClassfyIpadViewController
@synthesize listContent,alertListContent,player,noResultToDisplay,languageButton,freqButton,resourceButton,resetButton,alertTableView,myAlertView,clickTag,languageName,resourceName,freqName;
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
        splitViewController = [[UISplitViewController alloc] initWithNibName:@"ClassfyIpadViewController" bundle:nil];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类检索" image:[UIImage imageNamed:@"icon_copy.png"] tag:2];
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
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
    self.tableView.tag = 0;
    languageName = @"语言:全部";
    resourceName = @"类型:全部";
    freqName = @"常见程度:全部";
    clickTag = 1;
    // 添加一个tableView
    alertTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 225)];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tag = 1;
    //设置标题
	//self.title = @"分类检索";
    noResultToDisplay = TRUE;
	self.tableView.scrollEnabled = YES;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 318, 44)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    [buttons addObject:spacer];
    [spacer release];
    
    languageButton = [[UIBarButtonItem alloc]
                      initWithTitle:languageName
                      style:UIBarButtonItemStyleBordered
                      target:self
                      action:@selector(changeAction:)];
    languageButton.tag = 1;
    [buttons addObject:languageButton];
    
    resourceButton = [[UIBarButtonItem alloc]
                      initWithTitle:resourceName
                      style:UIBarButtonItemStyleBordered
                      target:self
                      action:@selector(changeAction:)];
    resourceButton.tag = 2;
    [buttons addObject:resourceButton];
    
    freqButton = [[UIBarButtonItem alloc]
                  initWithTitle:freqName
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:@selector(changeAction:)];
    freqButton.tag = 3;
    [buttons addObject:freqButton];
    
    resetButton = [[UIBarButtonItem alloc]
                   initWithTitle:@"重置"
                   style:UIBarButtonItemStyleDone
                   target:self
                   action:@selector(changeAction:)];
    resetButton.tag = 0;
    [buttons addObject:resetButton];
    
    [toolbar setItems:buttons animated:NO];
    toolbar.barStyle = -1;
    [buttons release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
    [toolbar release];
    
    //初始化一个alertView
    myAlertView = [[UIAlertView alloc] initWithTitle: @"请选择一个分类"
                                             message: @"\n\n\n\n\n\n\n\n\n\n\n"
                                            delegate: nil 
                                   cancelButtonTitle: @"取消"
                                   otherButtonTitles: nil];
}

- (void)changeAction:(id)sender
{
    UIBarButtonItem *buttonItem = (UIBarButtonItem*)sender;
    clickTag = buttonItem.tag;
    if (buttonItem.tag == 0) {
        languageButton.title = languageName;
        resourceButton.title = resourceName;
        freqButton.title = freqName;
        [self fiterData];
    }
    else {
        DataBase *db = [[DataBase alloc] init];
        if (buttonItem.tag == 1) {
            myAlertView.title = @"请选择一个语言分类";
            self.alertListContent = [db getDictInfo:400];
        }
        else if (buttonItem.tag == 2){
            myAlertView.title = @"请选择一个类型分类";
            self.alertListContent = [db getDictInfo:100];
        }
        else if (buttonItem.tag == 3){
            myAlertView.title = @"请选择一个常见程度分类";
            self.alertListContent = [db getDictInfo:200];
        }
        [alertTableView reloadData];
        [myAlertView addSubview: alertTableView];
        [db release];
        [myAlertView show];
    }
}

- (void)fiterData
{
    NSMutableString *conditionSql = [[NSMutableString alloc] init];
    NSComparisonResult result = [languageButton.title compare:languageName];
    if (result != NSOrderedSame) {
        [conditionSql appendFormat:@" and wi_language like '%%%@%%'",[languageButton.title substringFromIndex:3]];
    }
    result = [resourceButton.title compare:resourceName];
    if (result != NSOrderedSame) {
        [conditionSql appendFormat:@" and exists(select 1 from sys_dict where id=wi_resource_class and name = '%@')",[resourceButton.title substringFromIndex:3]];
    }
    result = [freqButton.title compare:freqName];
    if (result != NSOrderedSame) {
        [conditionSql appendFormat:@" and exists(select 1 from sys_dict where id=wi_freq_deep and name = '%@')",[freqButton.title substringFromIndex:5]];
    }
    DataBase *db = [[DataBase alloc] init];
    self.listContent = [db quaryTable:conditionSql type:0];
    [conditionSql release];
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
    if (tableView.tag == 0) {
        if ([self.listContent count] == 0) {
            noResultToDisplay = TRUE;
        }
        else {
            noResultToDisplay = FALSE;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        tableView.rowHeight = 66;
        if (noResultToDisplay) {
            return 1;
        }
        else {
            return [self.listContent count];
        }
    }
    else {
        return [self.alertListContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    if (tableView.tag == 0) {
        MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (noResultToDisplay) {
            cell.nameLabel.text = @"当前还没有匹配的分类信息";
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
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        DictInfo *dictInfo = [self.alertListContent objectAtIndex:indexPath.row];
        cell.textLabel.text = dictInfo.dictName;
        return cell;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (!noResultToDisplay) {
            MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];
            detailViewController.title = musicInfo.wi_name;
            //记录访问历史
            DataBase *db = [[DataBase alloc] init];
            [db saveHistory:musicInfo.wi_id type:1];
            [db release];
            UIViewController *scrollViewController = [[UIViewController alloc] init];
            MyDetailView *myDetailView = [[MyDetailView alloc] init];
            [myDetailView setDetailsView:musicInfo withType:2];
            scrollViewController.view = myDetailView;
            [myDetailView release];
            scrollViewController.title = musicInfo.wi_name;
            NSMutableArray *itemsArray = [detailViewController.navigationBar.topItem.rightBarButtonItems mutableCopy];
            [detailViewController pushViewController:scrollViewController animated:YES];
            [scrollViewController release];
            if (itemsArray != nil && itemsArray.count > 0) {
                [detailViewController.navigationBar.topItem setRightBarButtonItems:itemsArray animated:NO];
            }
            [itemsArray release];
        }
    }
    else {
        DictInfo *dictInfo = [self.alertListContent objectAtIndex:indexPath.row];
        switch (clickTag) {
            case 2:
                resourceButton.title = [NSString stringWithFormat:@"类型:%@",dictInfo.dictName];
                break;
            case 3:
                freqButton.title = [NSString stringWithFormat:@"常见程度:%@",dictInfo.dictName];
                break;
            default:
                languageButton.title = [NSString stringWithFormat:@"语言:%@",dictInfo.dictName];
                break;
        }
        NSUInteger cancelButtonIndex = myAlertView.cancelButtonIndex;
        [myAlertView dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
        [self fiterData];
    }
}


/**
 * 初始化search bar时讲取消按钮的标题更改为中文
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)cc;
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
    [alertListContent release];
	[languageButton release];
    [freqButton release];
    [resourceButton release];
    [resetButton release];
    [player release];
    [alertTableView release];
    [myAlertView retain];
    languageName = nil;
    resourceName = nil;
    freqName = nil;
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
