//
//  ViewController.m
//  SliderSwitch
//
//  Created by kkmm on 2018/10/16.
//  Copyright © 2018 kkmm. All rights reserved.
//

#import "ViewController.h"
#import "SonViewController.h"
#import "NLSliderSwitch.h"
#define KScreen [UIScreen mainScreen].bounds.size
#define TopBarHeight (([UIScreen mainScreen].bounds.size.height >= 812.0) ? 88.f : 64.f)
@interface ViewController ()<NLSliderSwitchDelegate,UIScrollViewDelegate>
//滚动页面，左右滑动切换页面
@property (nonatomic, strong) UIScrollView * backScrollV;

//滑条
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationController.navigationBar.translucent = YES;
	[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255. green:144/255. blue:255/255. alpha:1.]];

	[self setUI];
	
}

- (void)setUI
{
	self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight, KScreen.width,KScreen.height-TopBarHeight)];
	self.backScrollV.pagingEnabled = YES;
	self.backScrollV.delegate = (id)self;
	self.backScrollV.showsVerticalScrollIndicator = NO;
	self.backScrollV.showsHorizontalScrollIndicator = NO;
	self.backScrollV.bounces = NO;
	self.backScrollV.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.backScrollV];
	//	self.backScrollV.scrollEnabled = NO;
	self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 1);//禁止竖向滚动
	[self.backScrollV scrollRectToVisible:CGRectMake(KScreen.width,0, KScreen.width, 1) animated:NO];
	
	SonViewController *sonViewControllerLeft = [[SonViewController alloc]init];
	sonViewControllerLeft.delegateVC = self;
	[self addChildViewController:sonViewControllerLeft];
	[sonViewControllerLeft.view setFrame:CGRectMake(0, 0, KScreen.width, self.backScrollV.frame.size.height)];
	sonViewControllerLeft.view.backgroundColor = [UIColor blueColor];
	sonViewControllerLeft.title = @"左边";
	[self.backScrollV addSubview:sonViewControllerLeft.view];
	
	SonViewController *sonViewControllerCenter = [[SonViewController alloc]init];
	sonViewControllerCenter.delegateVC = self;
	[self addChildViewController:sonViewControllerCenter];
	[sonViewControllerCenter.view setFrame:CGRectMake(KScreen.width, 0, KScreen.width, self.backScrollV.frame.size.height)];
	sonViewControllerCenter.view.backgroundColor = [UIColor yellowColor];
	sonViewControllerCenter.title = @"中间";
	[self.backScrollV addSubview:sonViewControllerCenter.view];
	
	SonViewController *sonViewControllerRight = [[SonViewController alloc]init];
	sonViewControllerRight.delegateVC = self;
	[self addChildViewController:sonViewControllerRight];
	[sonViewControllerRight.view setFrame:CGRectMake(2*KScreen.width, 0, KScreen.width, self.backScrollV.frame.size.height)];
	sonViewControllerRight.view.backgroundColor = [UIColor purpleColor];
	sonViewControllerRight.title = @"右边";
	[self.backScrollV addSubview:sonViewControllerRight.view];
	
	
	self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake(0, 0, 159, 40) buttonSize:CGSizeMake(53, 30)];
	self.sliderSwitch.titleArray = @[@"左边",@"中间",@"右边"];
	self.sliderSwitch.normalTitleColor = [UIColor whiteColor];
	self.sliderSwitch.selectedTitleColor = [UIColor whiteColor];
	self.sliderSwitch.selectedButtonColor = [UIColor whiteColor];
	self.sliderSwitch.titleFont = [UIFont systemFontOfSize:15];
	self.sliderSwitch.backgroundColor = [UIColor clearColor];
	self.sliderSwitch.delegate = (id)self;
	self.sliderSwitch.viewControllers = @[sonViewControllerLeft,sonViewControllerCenter,sonViewControllerRight];
	self.navigationItem.titleView = self.sliderSwitch;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if (scrollView == self.backScrollV) {
		float xx = scrollView.contentOffset.x;
		int rate = round(xx/KScreen.width);
		if (rate != self.sliderSwitch.selectedIndex) {
			[self.sliderSwitch slideToIndex:rate];
		}
	}
}

-(void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex{
	[self.backScrollV scrollRectToVisible:CGRectMake(selectedIndex*KScreen.width,0, KScreen.width, 1) animated:YES];
	
}

@end
