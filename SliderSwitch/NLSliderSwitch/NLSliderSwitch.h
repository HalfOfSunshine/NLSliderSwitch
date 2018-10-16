//
//  KMSwitchButtons.h
//  ScrollerTab
//
//  Created by kkmm on 2018/8/9.
//  Copyright © 2018年 kkmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSliderSwitchProtocol.h"
@class NLSliderSwitch;
@protocol NLSliderSwitchDelegate <NSObject>

@optional
/*! 选中selectedIndex 回调*/
- (void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex;

@end


@interface NLSliderSwitch <T>: UIView
/*! title的数据源*/
@property(nonatomic,strong) NSArray *titleArray;
/*! title的未选中字色*/
@property(nonatomic,strong) UIColor *normalTitleColor;
/*! title的选中字色*/
@property(nonatomic,strong) UIColor *selectedTitleColor;
/*! title字体*/
@property(nonatomic,strong) UIFont *titleFont;
/*! 选中按钮颜色*/
@property(nonatomic,strong) UIColor *selectedButtonColor;
/*! button宽高*/
@property(nonatomic,assign) CGSize buttonSize;
/*! 滑块*/
@property(nonatomic,strong)CALayer *sliderLayer;
/*! viewControllers控制器数组*/
@property(nonatomic,strong)NSArray <T<NLSliderSwitchProtocol>> *viewControllers;
/*! 选中按钮字体是否变粗，默认变粗*/
@property(nonatomic) BOOL selectedFontBlod;

/*! 当前选中index*/
@property(nonatomic,readonly) NSInteger selectedIndex;



@property(nonatomic,weak) id<NLSliderSwitchDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame buttonSize:(CGSize)size;

/*! 滑动到idx*/
-(void)slideToIndex:(NSInteger)idx;

/*! 滑动到idx 是否加载动画*/
-(void)slideToIndex:(NSInteger)idx animated:(BOOL)animated;

@end

