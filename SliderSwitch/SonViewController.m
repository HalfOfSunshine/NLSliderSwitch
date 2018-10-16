//
//  SonViewController.m
//  SliderSwitch
//
//  Created by kkmm on 2018/10/16.
//  Copyright © 2018 kkmm. All rights reserved.
//

#import "SonViewController.h"
#import "NLSliderSwitchProtocol.h"
@interface SonViewController ()<NLSliderSwitchProtocol>

@end

@implementation SonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidScrollToVisiableArea{
	NSLog(@"当前滑动到了‘%@’页面",self.title);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
