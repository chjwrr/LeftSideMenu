//
//  BaseNavigationController.m
//  CocoaPodsTest
//
//  Created by Mac on 2017/4/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@property (nonatomic,strong)UIView *view_top;

@end

@implementation BaseNavigationController
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        
        //禁止系统的侧滑
        self.interactivePopGestureRecognizer.enabled=NO;
        
        // 屏幕边缘pan手势(优先级高于其他手势)
        _leftEdgeGesture = \
        [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handle:)];
        _leftEdgeGesture.edges = UIRectEdgeLeft;           // 屏幕左侧边缘响应
        [self.view addGestureRecognizer:_leftEdgeGesture]; // 给self.view添加上
        
        
        
        //菜单出来时，中间视图上覆盖一层半透明的View
        _view_top=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [self.view addSubview:_view_top];
        _view_top.userInteractionEnabled=YES;
        _view_top.backgroundColor=[UIColor blackColor];
        _view_top.alpha= 0.0;
        _view_top.hidden=YES;
        
        //添加点击手势，点击回到原始状态
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(normalState)];
        [_view_top addGestureRecognizer:tap];
        
        //添加pan手势，半透明view向左滑动
        UIPanGestureRecognizer *leftPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(leftPan:)];
        [_view_top addGestureRecognizer:leftPan];
    }
    
    return self;
}


//右滑方法，
- (void)handle:(UIPanGestureRecognizer *)recognizer {
    
    //只有topViewController才会触发侧栏
    if (self.viewControllers.count != 1) {
        return;
    }
    
    
    
    //velocityInView：在指定坐标系统中pan gesture拖动的速度
    //CGPoint velocity=[recognizer velocityInView:self.view];
    
    //translationInView：获取到的是手指移动后，在相对坐标中的偏移量
    CGPoint translatio=[recognizer translationInView:self.view];

    
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        NSLog(@"UIGestureRecognizerStateBegan");
        self.view_top.hidden=NO;

    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        
        if (translatio.x < 0) {
            return;
        }
        
        //通知，盖面MainVC中leftView和centerView的位置
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateChanged" object:nil userInfo:@{@"width":[NSNumber numberWithFloat:translatio.x]}];

        
        //改变半透明View的透明度
        int a=(int)translatio.x;
        
        int b=(int)kLeftWidth;
        
        CGFloat viewAlpha=a/(CGFloat)b;

        
        if (viewAlpha>1.0) {
            self.view_top.alpha=kViewTopAlpha;

        }else
            self.view_top.alpha=kViewTopAlpha*viewAlpha;
        


    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded ) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        
        //通知，滑动结束后，改变对一个的状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateEnded" object:nil userInfo:@{@"width":[NSNumber numberWithFloat:translatio.x]}];

        //滑动的距离小于最小滑动距离，状态不改变 ，反之改变
        if (translatio.x <= kLeftMinWidth) {
            self.view_top.hidden=YES;
        }else{
            self.view_top.alpha=kViewTopAlpha;
        }
        
    }
    
}


//半透明View左滑
- (void)leftPan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translatio=[recognizer translationInView:self.view];

    
    NSLog(@"%@",NSStringFromCGPoint(translatio));
    
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        NSLog(@"UIGestureRecognizerStateBegan");
        self.view_top.hidden=NO;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        
        
        if (translatio.x <= 0) {
            //左滑
            
            CGFloat widthSpace=kLeftWidth+translatio.x;
            
            if (translatio.x <= -kLeftWidth) {
                widthSpace=0.0;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateChanged" object:nil userInfo:@{@"width":[NSNumber numberWithFloat:widthSpace]}];
            
            
            //改变半透明View的透明度
            int a=(int)widthSpace;
            int b=(int)kLeftWidth;
            
            CGFloat viewAlpha=a/(CGFloat)b;
            
            self.view_top.alpha=kViewTopAlpha*viewAlpha;
            
            
        }
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded ) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        
        
        //滑动的距离小于最小滑动距离，状态不改变 ，反之改变

        if (translatio.x <= 0 && translatio.x >=-kLeftMinWidth) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateEnded" object:nil userInfo:@{@"width":[NSNumber numberWithFloat:kLeftMinWidth]}];

        }else if (translatio.x < -kLeftMinWidth) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateNormal" object:nil];
            
            [self normalState];
        }
        
        
    }

    
}
- (void)normalState {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIGestureRecognizerStateNormal" object:nil];

    [UIView animateWithDuration:0.25 animations:^{
        self.view_top.alpha=0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.view_top.hidden=YES;
        }
    }];
}


#pragma mark - 滑动开始会触发

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (self.navigationController.viewControllers.count == 1) {
//        return NO;
//    }else{
//        return YES;
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
