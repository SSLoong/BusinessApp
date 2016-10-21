//
//  PerfectDate.m
//  PerfectDateChoose
//
//  Created by prefect on 16/3/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PerfectDate.h"
#import "MHDatePicker.h"
//#define ScreenWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)
// 屏幕尺寸 ScreenRect
#define ScreenRect [UIScreen mainScreen].applicationFrame
#define ScreenRectHeight [UIScreen mainScreen].applicationFrame.size.height
#define ScreenRectWidth [UIScreen mainScreen].applicationFrame.size.width

@interface PerfectDate()

@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic) MHDatePicker *selectDatePicker;
@property(nonatomic,assign)BOOL show;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,assign)CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property(nonatomic,strong)UIView *transformView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *sView1;
@property(nonatomic,strong)UIView *sView2;
@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UILabel *startLabel;
@property(nonatomic,strong)UILabel *endLabel;
@property(nonatomic,strong)UIButton *btn;


@end


@implementation PerfectDate


-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _origin = origin;
        _height = height;
        _show = NO;

        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        
        
        
        _sView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 44)];
        _sView1.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_sView1];
        
        UIGestureRecognizer *sGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sTapped1)];
        [_sView1 addGestureRecognizer:sGesture1];
        
        
        
        
        _sView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.bounds.size.width, 44)];
        _sView2.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_sView2];
        
        UIGestureRecognizer *sGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sTapped2)];
        [_sView2 addGestureRecognizer:sGesture2];
        
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        _imageView1.image = [UIImage imageNamed:@"timeImage"];
        [_sView1 addSubview:_imageView1];
        
        _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        _imageView2.image = [UIImage imageNamed:@"timeImage"];
        [_sView2 addSubview:_imageView2];
        
        _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-90, 16, 80, 12)];
        _startLabel.text = @"起始日期";
        _startLabel.textColor = [UIColor grayColor];
        _startLabel.font = [UIFont systemFontOfSize:12.f];
        _startLabel.textAlignment = NSTextAlignmentRight;
        [_sView1 addSubview:_startLabel];
        
        
        _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-90, 16, 80, 12)];
        _endLabel.text = @"结束日期";
        _endLabel.textColor = [UIColor grayColor];
        _endLabel.font = [UIFont systemFontOfSize:12.f];
        _endLabel.textAlignment = NSTextAlignmentRight;
        [_sView2 addSubview:_endLabel];
        
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_btn setTitle:@"确 认" forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor colorWithRed:(253/255.f) green:(91/255.f) blue:(68/255.f) alpha:1.f];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView  addSubview:_btn];

        
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
//        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
//        bottomShadow.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:bottomShadow];
        
    }
    return self;
}


- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

-(void)sTapped1{
    
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {

        weakSelf.startLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];

    }];
    
}

-(void)sTapped2{

    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        
        weakSelf.endLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        
    }];
    

}



-(void)hideView{

    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableViewShow:NO complete:^{
            _show = NO;
        }];
    }];

}

-(void)btnAction:(id)sender{

    if ([_startLabel.text isEqualToString:@"起始日期"] || [_endLabel.text isEqualToString:@"结束日期"]) {
        
        return;
    }
    
    if (self.didSelectBtn) {
        self.didSelectBtn(_startLabel.text,_endLabel.text);
        
        
        
        
    }
}



#pragma mark - gesture handle

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableViewShow:NO complete:^{
            _show = NO;
        }];
    }];
}



-(void)clickBtn{
    

    [self animateBackGroundView:_backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{

            _show = !_show;
        }];
    }];
    
}






- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}




- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    if (show) {
        
        _bgView.frame = CGRectMake(self.origin.x, self.frame.origin.y, self.bounds.size.width, 0);

        _btn.frame = CGRectMake(10, 114, self.bounds.size.width-20, 0);
        
        [self.superview addSubview:_bgView];
        
        _bgView.alpha = 1.f;

        [UIView animateWithDuration:0.2 animations:^{

        _bgView.frame = CGRectMake(self.origin.x, self.frame.origin.y, self.bounds.size.width, _height);
            
        _btn.frame = CGRectMake(10, 114, self.bounds.size.width-20, 38);
            
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            
            [_bgView removeFromSuperview];
        }];
    }
    complete();
}



@end
