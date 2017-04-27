//
//  MainViewController.m
//  CocoaPodsTest
//
//  Created by Mac on 2017/4/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "ViewController.h"



@interface MainViewController ()

@property (nonatomic,strong)LeftViewController *leftVC;
@property (nonatomic,strong)ViewController *centerVC;
@property (nonatomic,strong)BaseNavigationController *nav;
@property (nonatomic,strong)BaseViewController *currentVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //左侧视图
    self.leftVC=[[LeftViewController alloc]init];
    [self addChildViewController:self.leftVC];
    
    //中间视图，有导航
    self.centerVC=[[ViewController alloc]init];
    self.nav=[[BaseNavigationController alloc]initWithRootViewController:self.centerVC];
    [self addChildViewController:self.nav];
    
    [self.view addSubview:self.leftVC.view];
    [self.view addSubview:self.nav.view];
    
    
    //左侧x为负值，目的为了向右滑动时有左侧出来的效果
    self.leftVC.view.frame=CGRectMake(-screenWidth/4, 0, screenWidth, screenHeight);
    self.nav.view.frame=CGRectMake(0, 0, screenWidth, screenHeight);

    //滑动过程中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFrame:) name:@"UIGestureRecognizerStateChanged" object:nil];
    //滑动结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFrameEND:) name:@"UIGestureRecognizerStateEnded" object:nil];
    //原始状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewFrameNormal) name:@"UIGestureRecognizerStateNormal" object:nil];

}

//滑动过程中改变布局,
- (void)changeViewFrame:(NSNotification *)notification {
    
    NSNumber *panWidth=[notification.userInfo objectForKey:@"width"];
    
    CGFloat leftWidth=panWidth.floatValue;
    if (leftWidth >= kLeftWidth) {
        leftWidth=kLeftWidth;
    }
    
    self.nav.view.frame=CGRectMake(leftWidth, 0, screenWidth, screenHeight);
    self.leftVC.view.frame=CGRectMake(-screenWidth/4+leftWidth/3, 0, screenWidth, screenHeight);//移动时两个视图移动速度不同，造成视差效果
}

//滑动结束，更新布局
- (void)changeViewFrameEND:(NSNotification *)notification {
    
    
    NSNumber *panEndWidth=[notification.userInfo objectForKey:@"width"];
    
    if (panEndWidth.floatValue <= kLeftMinWidth) {
        //恢复原始状态
        [self changeViewFrameNormal];
        
    }
    
    if (panEndWidth.floatValue >= kLeftMinWidth) {
        //更新到侧栏状态
        [UIView animateWithDuration:0.25 animations:^{
            self.nav.view.frame=CGRectMake(kLeftWidth, 0, screenWidth, screenHeight);
            self.leftVC.view.frame=CGRectMake(-screenWidth/4+kLeftWidth/3, 0, screenWidth, screenHeight);//移动时两个视图移动速度不同，造成视差效果
        }];
        
    }
    
    
}

//原始状态
- (void)changeViewFrameNormal {
    [UIView animateWithDuration:0.25 animations:^{
        self.nav.view.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        self.leftVC.view.frame=CGRectMake(-screenWidth/4, 0, screenWidth, screenHeight);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
