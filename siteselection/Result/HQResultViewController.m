//
//  HQResultViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/24.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQResultViewController.h"
#import "HQFlowInfoViewController.h"
#import "HQCompeteStoreViewController.h"
#import "WaitingStoreViewController.h"
#import "AFRequest.h"
#import "HQSave.h"
@interface HQResultViewController ()
{
    UIView *_resultView;
}
@property (nonatomic, weak) CAShapeLayer *progressLayer;
@property (nonatomic, weak) UILabel      *index;
@property (nonatomic, weak) UILabel      *indexRange;
@property (nonatomic, weak) UIButton      *flow;
@property (nonatomic, weak) UIButton      *hose;
@property (nonatomic, weak) UIButton      *store;

@end

@implementation HQResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分析结果";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initDashboard];
    [self loadResult];
    [self loadResultView];
}
- (void)loadResultView {
    double lat = [HQSave shared].selectLocation.latitude;
    double lon = [HQSave shared].selectLocation.longitude;
    NSString *url = [NSString stringWithFormat:@"http://10.1.1.14/sitetesting.5/index.php/getresult/method/%lf/%lf",lat,lon];
    __weak HQResultViewController *tmpSelf = self;
    [AFRequest GET:url success:^(id responseObject) {
        [tmpSelf success:responseObject];
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadResult {
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(_indexRange.frame)+20, [UIScreen mainScreen].bounds.size.width-60, ( [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_indexRange.frame))*0.618)];
    red.alpha = 0;
    red.backgroundColor = [UIColor whiteColor];
    red.layer.cornerRadius = 3;
    red.clipsToBounds = YES;
    red.layer.borderWidth = 1;
    red.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, red.frame.size.height/3, red.frame.size.width, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, red.frame.size.height/3*2, red.frame.size.width, 1)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [red addSubview:line1];
    [red addSubview:line2];
    UIButton *label1 = [UIButton buttonWithType:UIButtonTypeInfoLight];
    label1.frame = CGRectMake(0, 0, red.frame.size.width, red.frame.size.height/3);
    
    [label1 addTarget:self action:@selector(flowInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [red addSubview:label1];
    UIButton *label2 = [UIButton buttonWithType:UIButtonTypeInfoLight];
    label2.frame = CGRectMake(10, red.frame.size.height/3, red.frame.size.width, red.frame.size.height/3);
    [label2 addTarget:self action:@selector(waitingStoreClick) forControlEvents:UIControlEventTouchUpInside];
    [red addSubview:label2];
    UIButton *label3 = [UIButton buttonWithType:UIButtonTypeInfoLight];
    label3.frame = CGRectMake(10, red.frame.size.height/3*2, red.frame.size.width, red.frame.size.height/3);
    [label3 addTarget:self action:@selector(competeStoreClick) forControlEvents:UIControlEventTouchUpInside];
    [red addSubview:label3];
    [self.view addSubview:red];
    _flow = label1;
    _hose = label2;
    _store = label3;
    _resultView = red;
}

- (void)success:(NSDictionary *)dict {
    float currentSpeed = [dict[@"index"][@"index"] floatValue];
    _indexRange.text = dict[@"index"][@"desc"];
    [_flow setTitle:dict[@"flow"][@"score"] forState: UIControlStateNormal];
    [_hose setTitle:dict[@"store_rent"][@"score"] forState: UIControlStateNormal];
    [_store setTitle:dict[@"competitor"][@"score"] forState: UIControlStateNormal];
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:1.f];
    _progressLayer.strokeEnd = currentSpeed * 0.01;
    [CATransaction commit];
//    _resultView.frame = CGRectMake(30,CGRectGetMaxY(_indexRange.frame)+5, [UIScreen mainScreen].bounds.size.width-60, ( [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_indexRange.frame))*0.618);
    
    [UIView animateWithDuration:0.1f animations:^{
        _resultView.frame = CGRectMake(30,CGRectGetMaxY(_indexRange.frame)+5, [UIScreen mainScreen].bounds.size.width-60, ( [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_indexRange.frame))*0.618);
        _resultView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)flowInfoClick {
    HQFlowInfoViewController *flowInfo = [[HQFlowInfoViewController alloc] init];
    [self.navigationController pushViewController:flowInfo animated:YES];
}
- (void)competeStoreClick {
    HQCompeteStoreViewController *compete = [[HQCompeteStoreViewController alloc] init];
    [self.navigationController pushViewController:compete animated:YES];
}
- (void)waitingStoreClick {
    WaitingStoreViewController *waiting = [[WaitingStoreViewController alloc] init];
    [self.navigationController pushViewController:waiting animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initDashboard {
    // 外环弧线
    UIView *backView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    backView.backgroundColor = [UIColor colorWithRed:0.14 green:0.59 blue:0.83 alpha:1.00];
    [self.view addSubview:backView];
    CAShapeLayer *outArc = [self drawCurveWithRadius:147.5];
    [self.view.layer addSublayer:outArc];
    
    // 内环弧线
    CAShapeLayer *inArc = [self drawCurveWithRadius:82.5];
    [self.view.layer addSublayer:inArc];
    // 绘制进度图层
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, 240)
                                                                 radius:115
                                                             startAngle:-M_PI
                                                               endAngle:0
                                                              clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.lineWidth     =  60.f;
    progressLayer.fillColor     = [[UIColor clearColor] CGColor];
    progressLayer.strokeColor   = [[UIColor whiteColor] CGColor];
    progressLayer.path          = progressPath.CGPath;
    progressLayer.strokeStart   = 0.0;
    progressLayer.strokeEnd     = 0.0;
    [self.view.layer addSublayer:progressLayer];
    _progressLayer = progressLayer;
    
    // 添加观察者，观察progressLayer的strokeEnd属性，以便为_lbel赋值
    [progressLayer addObserver:self
                    forKeyPath:@"strokeEnd"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    
    // 渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[[UIColor colorWithRed:0.96 green:0.08 blue:0.10 alpha:1.00] CGColor],
                              (id)[[UIColor colorWithRed:0.97 green:0.65 blue:0.22 alpha:1.00] CGColor],
                              (id)[[UIColor colorWithRed:0.60 green:0.82 blue:0.22 alpha:1.00] CGColor],
                              (id)[[UIColor colorWithRed:0.20 green:0.63 blue:0.25 alpha:1.00] CGColor],
                              (id)[[UIColor colorWithRed:0.09 green:0.58 blue:0.15 alpha:1.00] CGColor],
                              nil]];
    [gradientLayer setLocations:@[@0, @0.25, @0.5, @0.75, @1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    [gradientLayer setMask:progressLayer];
    
    [self.view.layer addSublayer:gradientLayer];
    
    // 绘制刻度
    CGFloat perAngle = M_PI / 50; // 一刻度的弧度值
    CGFloat calWidth = perAngle / 5; // 刻度线的宽度
    
    for (int i = 1; i< 50; i++) {
        
        CGFloat startAngel = -M_PI + perAngle * i;
        CGFloat endAngel   = startAngel + calWidth;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, 240)
                                                                radius:140
                                                            startAngle:startAngel
                                                              endAngle:endAngel
                                                             clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        
        if (i % 5 == 0) {
            
            perLayer.strokeColor = [[UIColor whiteColor] CGColor];
            perLayer.lineWidth   = 10.f;
            
            CGPoint point = [self calculateTextPositonWithArcCenter:CGPointMake(self.view.center.x, 240) angle:-startAngel];
            
            UILabel *calibration       = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 10, point.y - 10, 20, 20)];
            calibration.text           = [NSString stringWithFormat:@"%d", i * 2];
            calibration.font           = [UIFont systemFontOfSize:10];
            calibration.textColor      = [UIColor whiteColor];
            calibration.textAlignment  = NSTextAlignmentCenter;
            [self.view addSubview:calibration];
            
        }else{
            
            perLayer.strokeColor = [[UIColor colorWithRed:0.22 green:0.66 blue:0.87 alpha:1.0] CGColor];
            perLayer.lineWidth   = 5;
        }
        
        perLayer.path = tickPath.CGPath;
        
        [self.view.layer addSublayer:perLayer];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGPointMake(self.view.center.x, 240).x - 40,
                                                               CGPointMake(self.view.center.x, 240).y - 50,
                                                               80,
                                                               50)];
    label.textColor = [UIColor whiteColor];
    label.text = @"0";
    label.font = [UIFont boldSystemFontOfSize:35];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    _index = label;
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                             CGPointMake(self.view.center.x, 240).y,
                                                             self.view.bounds.size.width,
                                                             30)];
    tip.text = @"";
    backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGPointMake(self.view.center.x, 240).y + 45);
    tip.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    tip.font = [UIFont systemFontOfSize:16.f];
    tip.textAlignment = NSTextAlignmentCenter;
    _indexRange = tip;
    [self.view addSubview:tip];
}
/**
 绘制弧线
 
 @param radius 半径
 @return CAShapeLayer
 */
- (CAShapeLayer *)drawCurveWithRadius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, 240)
                                                        radius:radius
                                                    startAngle:-M_PI
                                                      endAngle:0
                                                     clockwise:YES];
    CAShapeLayer *curve = [CAShapeLayer layer];
    curve.lineWidth     = 5.f;
    curve.fillColor     = [[UIColor clearColor] CGColor];
    curve.strokeColor   = [[UIColor whiteColor] CGColor];
    curve.path          = path.CGPath;
    
    return curve;
}

/**
 计算Label位置
 
 @param center 中心点
 @param angel 角度
 @return CGPoint
 */
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center angle:(CGFloat)angel
{
    CGFloat calRadius = 125.f; // 刻度Label中心点所在圆弧的半径
    CGFloat x = calRadius * cosf(angel);
    CGFloat y = calRadius * sinf(angel);
    
    return CGPointMake(center.x + x, center.y - y);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"strokeEnd"]) {
        
        NSInteger value = [change[@"new"] floatValue] * 100;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 1.f;
        _index.text = [NSString stringWithFormat:@"%zd", value];
        [_index.layer addAnimation:animation forKey:nil];
    }
}
- (void)dealloc
{
    [_progressLayer removeObserver:self forKeyPath:@"strokeEnd"];
}
@end
