//
//  KMSwitchButtons.m
//  ScrollerTab
//
//  Created by kkmm on 2018/8/9.
//  Copyright © 2018年 kkmm. All rights reserved.
//

#import "NLSliderSwitch.h"

@interface NLSliderSwitch()<CAAnimationDelegate>
///*! 当前选中index*/
@property(nonatomic,readwrite) NSInteger selectedIndex;
@end
@implementation NLSliderSwitch
#define SelectedScale 1.5
#define UnSelectedScale (1/1.5)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame buttonSize:(CGSize)size
{
	self = [super initWithFrame:frame];
	if (self) {
		self.selectedIndex = 1;
		self.selectedFontBlod = YES;
		self.buttonSize = CGSizeMake(size.width*SelectedScale, size.height*SelectedScale);
		self.normalTitleColor = [UIColor grayColor];
		self.selectedTitleColor = [UIColor blackColor];
		_sliderLayer = [CALayer layer];

		_sliderLayer.frame = CGRectMake(self.buttonSize.width*self.selectedIndex*UnSelectedScale-(self.buttonSize.width-self.buttonSize.width*UnSelectedScale)/2+self.buttonSize.width/2-4, frame.size.height-6, 10, 4);

		_sliderLayer.masksToBounds = YES;
		_sliderLayer.backgroundColor = [UIColor blueColor].CGColor;
		_sliderLayer.cornerRadius = self.sliderLayer.frame.size.width<self.sliderLayer.frame.size.height?self.sliderLayer.frame.size.width/2.:self.sliderLayer.frame.size.height/2.;
		[self.layer addSublayer:_sliderLayer];
	}
	return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
	if (_titleArray != titleArray) {
		_titleArray = titleArray;
	}
	[titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.buttonSize.width*idx*UnSelectedScale-(self.buttonSize.width-self.buttonSize.width*UnSelectedScale)/2, (self.frame.size.height-self.buttonSize.height)/2, self.buttonSize.width, self.buttonSize.height)];
		button.layer.masksToBounds = YES;
		button.layer.cornerRadius = self.buttonSize.width<self.buttonSize.height?self.buttonSize.width/2.:self.buttonSize.height/2.;
		[button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
		button.backgroundColor = [UIColor clearColor];
		[button setTitle:titleArray[idx] forState:UIControlStateNormal];
		if (self.selectedIndex != idx) {
			[button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
			// 	缩小
			[CATransaction begin];
			[CATransaction setDisableActions:YES];
			button.layer.transform = CATransform3DMakeScale(UnSelectedScale, UnSelectedScale, 1);
			[CATransaction commit];
		}else{
			[button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
		}
		button.tag = idx+9000;
		[self addSubview:button];
	}];
}

-(void)setTitleFont:(UIFont *)titleFont{
	if (_titleFont != titleFont) {
		_titleFont = titleFont;
	}
	for (NSObject *btn in self.subviews) {
		if ([btn isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)btn;
			if ((button.tag-9000 == _selectedIndex)&&_selectedFontBlod) {
				button.titleLabel.font = [UIFont boldSystemFontOfSize:[titleFont pointSize]*SelectedScale];
			}else{
				button.titleLabel.font = [UIFont systemFontOfSize:[titleFont pointSize]*SelectedScale];
			}
		}
	}
}

-(void)setNormalTitleColor:(UIColor *)normalTitleColor{
	if (_normalTitleColor != normalTitleColor) {
		_normalTitleColor = normalTitleColor;
	}
	for (NSObject *btn in self.subviews) {
		if ([btn isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)btn;
			if (button.tag != self.selectedIndex+9000) {
				[button setTitleColor:normalTitleColor forState:UIControlStateNormal];
			}
		}
	}
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
	if (_selectedTitleColor != selectedTitleColor) {
		_selectedTitleColor = selectedTitleColor;
	}
	UIButton *button=(UIButton *)[self viewWithTag:self.selectedIndex+9000];
	[button setTitleColor:selectedTitleColor forState:UIControlStateNormal];
}

-(void)setSelectedButtonColor:(UIColor *)selectedButtonColor{
	if (_selectedButtonColor != selectedButtonColor) {
		_selectedButtonColor = selectedButtonColor;
	}
	_sliderLayer.backgroundColor = selectedButtonColor.CGColor;
}

-(void)clickEvent:(UIButton *)sender
{
	[self slideToIndex:sender.tag-9000 animated:YES];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//	if (self.delegate && [self.delegate respondsToSelector:@selector(kmSwitch:didSelectedIndex:)]) {
//		[self.delegate kmSwitch:self didSelectedIndex:index];
//}
-(void)slideToIndex:(NSInteger)idx{
	[self slideToIndex:idx animated:YES];
}

-(void)slideToIndex:(NSInteger)idx animated:(BOOL)animated;
{
	UIButton *button=(UIButton *)[self viewWithTag:idx+9000];
	
	[button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
	
	UIButton *lastbutton=(UIButton *)[self viewWithTag:(NSInteger)(self.selectedIndex+9000)];
	
	NSInteger index = button.tag-9000;
	if(index == self.selectedIndex){
		return;
	}else{
		[lastbutton setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(sliderSwitch:didSelectedIndex:)]) {
		[self.delegate sliderSwitch:self didSelectedIndex:index];
	}
	if (animated){
		//滑动
		self.sliderLayer.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2-5, self.sliderLayer.frame.origin.y, self.sliderLayer.frame.size.width, self.sliderLayer.frame.size.height);

		//	长短
		CABasicAnimation *sliderAnimation = [CABasicAnimation animation];
		sliderAnimation.keyPath = @"transform.scale.x";
		sliderAnimation.toValue = [NSNumber numberWithFloat:self.buttonSize.width/self.sliderLayer.frame.size.width];
		sliderAnimation.autoreverses = YES;
		sliderAnimation.speed = 3;			//3倍速运行，2倍的时候，最后的动作粘在button上进行
		[self.sliderLayer addAnimation:sliderAnimation forKey:@"sliderAnimation"];
		// 	放大
		CABasicAnimation *selectedAnimation = [CABasicAnimation animation];
		selectedAnimation.keyPath = @"transform.scale";
		selectedAnimation.toValue = @1.0;
		selectedAnimation.removedOnCompletion = NO;
		selectedAnimation.fillMode = kCAFillModeForwards;
		[button.layer addAnimation:selectedAnimation forKey:@"selectedAnimation"];
		if (self.selectedFontBlod) button.titleLabel.font = [UIFont boldSystemFontOfSize:[_titleFont pointSize]*SelectedScale];
		//	缩小
		CABasicAnimation *unSelectedAnimation = [CABasicAnimation animation];
		unSelectedAnimation.keyPath = @"transform.scale";
		unSelectedAnimation.toValue = @(UnSelectedScale);
		unSelectedAnimation.removedOnCompletion = NO;
		unSelectedAnimation.fillMode = kCAFillModeForwards;
		[lastbutton.layer addAnimation:unSelectedAnimation forKey:@"unSelectedAnimation"];
		if (self.selectedFontBlod) lastbutton.titleLabel.font = [UIFont systemFontOfSize:[_titleFont pointSize]*SelectedScale];
		self.selectedIndex = index;
	}else{
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		self.sliderLayer.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2-5, self.sliderLayer.frame.origin.y, self.sliderLayer.frame.size.width, self.sliderLayer.frame.size.height);
		[button.layer removeAllAnimations];
		[lastbutton.layer removeAllAnimations];

		button.layer.transform = CATransform3DMakeScale(1, 1, 1);
		if (self.selectedFontBlod) button.titleLabel.font = [UIFont boldSystemFontOfSize:[_titleFont pointSize]*SelectedScale];
		lastbutton.layer.transform = CATransform3DMakeScale(UnSelectedScale, UnSelectedScale, 1);
		if (self.selectedFontBlod) lastbutton.titleLabel.font = [UIFont systemFontOfSize:[_titleFont pointSize]*SelectedScale];
		[CATransaction commit];
		self.selectedIndex = index;

		
	}
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
	if (_selectedIndex!=selectedIndex) {
		_selectedIndex = selectedIndex;
	}
	if ([self.viewControllers[selectedIndex] respondsToSelector:@selector(viewDidScrollToVisiableArea)]) {
		[self.viewControllers[selectedIndex] viewDidScrollToVisiableArea];
	}
}

@end
