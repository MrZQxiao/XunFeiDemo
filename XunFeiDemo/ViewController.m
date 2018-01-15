//
//  ViewController.m
//  XunFeiDemo
//
//  Created by 肖兆强 on 2018/1/13.
//  Copyright © 2018年 ZQDemo. All rights reserved.
//
#define screen_width [UIScreen mainScreen].bounds.size.width


#import "ViewController.h"
#import "iflyMSC/IFlyMSC.h"



#import "ISRDataHelper.h"



@interface ViewController ()
<IFlyRecognizerViewDelegate,UITextViewDelegate>

{
    
    IFlyRecognizerView *_iflyRecognizerView;
    
    NSString *_resultStr;
    
    NSMutableArray *_dataSourceArray;
    
}


@property (nonatomic,strong)UITextView *textField;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initViews];
    
}
-(void)initData{
    
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)initViews{
    
    //搜索框
    
    self.textField = [[UITextView alloc] initWithFrame:CGRectMake(20, 64+10, screen_width-40, 200)];
    
    self.textField.delegate = self;
    
    
    self.textField.text = @"";
    
    self.textField.backgroundColor = [UIColor lightGrayColor];
    
    self.textField.font = [UIFont systemFontOfSize:14];
    
    
    [self.view addSubview:self.textField];
    
    
    
    
    
    //语音按钮
    CGFloat voiceBtnW = 50;
    CGFloat voiceBtnX = (screen_width - voiceBtnW)*0.5;
    CGFloat voiceBtnY = self.view.bounds.size.height - voiceBtnW - 20;
    UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(voiceBtnX, voiceBtnY, voiceBtnW, voiceBtnW)];
    [voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:voiceBtn];
   
    
    
}



//有界面

-(void)initRecognizer{
    
    //单例模式，UI的实例
    
    if (_iflyRecognizerView == nil) {
        
        //UI显示剧中
        
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        
        
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        
        
        //设置听写模式
        
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        
        
    }
    
    _iflyRecognizerView.delegate = self;
    
    
    
    if (_iflyRecognizerView != nil) {
        
        //设置最长录音时间
        
        [_iflyRecognizerView setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        
        //设置后端点 3000
        
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        
        //设置前端点   3000
        
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        
        //设置采样率，推荐使用16K    16000
        
        [_iflyRecognizerView setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //        if ([instance.language isEqualToString:[IATConfig chinese]]) {
        
        //            //设置语言   zh_cn
        
        [_iflyRecognizerView setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        
        //            //设置方言  mandarin
        
        [_iflyRecognizerView setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        
        //        }else if ([instance.language isEqualToString:[IATConfig english]]) {
        
        //            //设置语言
        
        //            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        
        //        }
        
        //        //设置是否返回标点符号   0
        
        [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
        
        
    }
    
}



/**
 
 *  启动听写
 
 */

-(void)startBtn{
    
    if (_iflyRecognizerView == nil) {
        
        [self initRecognizer ];
        
    }
    
    //设置音频来源为麦克风
    
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    
    
    //设置听写结果格式为json
    
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    
    
    [_iflyRecognizerView start];
    
}








/**
 
 有界面，听写结果回调
 
 resultArray：听写结果
 
 isLast：表示最后一次
 
 ****/

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast

{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    
    
    for (NSString *key in dic) {
        
        [result appendFormat:@"%@",key];
        
    }
        self.textField.text =[NSString stringWithFormat:@"%@%@",_textField.text,result];
    
    [_iflyRecognizerView cancel];
}


- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"识别出错");
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
