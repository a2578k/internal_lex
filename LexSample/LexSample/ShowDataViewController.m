//
//  ShowDataViewController.m
//  LexSample
//
//  Created by LoftLabo on 2015/01/17.
//  Copyright (c) 2015年 LoftLabo. All rights reserved.
//

#import "ShowDataViewController.h"
#import "NSDictionary+Value.h"

@interface ShowDataViewController ()

@end

@implementation ShowDataViewController
@synthesize url_str;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"");
    UIBarButtonItem *close_btn =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Close"  // ボタンタイトル名を指定
     style:UIBarButtonItemStylePlain  // スタイルを指定（※下記表参照）
     target:self  // デリゲートのターゲットを指定
     action:@selector(closeAction)  // ボタンが押されたときに呼ばれるメソッドを指定
     ];
    self.navigationItem.rightBarButtonItem = close_btn;
    text_view.editable=NO;
    NSData *str_data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url_str]];
    NSString *string = [[NSString alloc] initWithData:str_data encoding:NSUTF8StringEncoding];
    NSMutableArray *item_array=[self html_lex:string];
    NSMutableString *wk_string = [NSMutableString string];
    for(NSDictionary *item_dict in item_array) {
        int type=[item_dict typeValue];
        if (type==JavaScriptType) {
            NSString *new_str=[NSString stringWithFormat:@"type=%d\n", type];
            [wk_string appendString:new_str];
        }else if (type==CssScriptType) {
            NSString *new_str=[NSString stringWithFormat:@"type=%d\n", type];
            [wk_string appendString:new_str];
        }else if (type==PhpCommentType) {
            NSString *new_str=[NSString stringWithFormat:@"type=%d\n", type];
            [wk_string appendString:new_str];
        }else if (type==HtmlCommentType) {
            NSString *new_str=[NSString stringWithFormat:@"type=%d\n", type];
            [wk_string appendString:new_str];
        }else if (type==HtmlCommentType) {
            NSString *new_str=[NSString stringWithFormat:@"type=%d\n", type];
            [wk_string appendString:new_str];
        }else{
            NSString *new_str=[NSString stringWithFormat:@"type=%d %@\n", type, [string substringWithRange:[item_dict rangeValue]]];
            [wk_string appendString:new_str];
        }
    }
    text_view.text=wk_string;
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
-(void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
// token作成
-(NSDictionary*)createTValue:(const char*)arg_cpr st_pt:(long)arg_st_pt ed_pt:(long)arg_ed_pt type:(enum TokenType)arg_type {
    // 233772
    if (last_input_point!=arg_st_pt) {
        if (last_input_point>arg_st_pt) {
            char *wcpr=(char*)arg_cpr;
            NSData *wkdata=[NSData dataWithBytes:wcpr length:(long)(last_input_point-arg_st_pt)];
            NSString *wstr=[[NSString alloc] initWithData:wkdata encoding:NSUTF8StringEncoding];
            end_input_point+=[wstr length];
        }else{
            char *wcpr=(char*)(arg_cpr+last_input_point);
            NSData *wkdata=[NSData dataWithBytes:wcpr length:(long)(arg_st_pt-last_input_point)];
            NSString *wstr=[[NSString alloc] initWithData:wkdata encoding:NSUTF8StringEncoding];
            end_input_point+=[wstr length];
        }
    }
    if (arg_st_pt>arg_ed_pt) {
        NSLog(@"Error !!!!!!!!!!!!!!!");
    }
    char *wcpr=(char*)(arg_cpr+arg_st_pt);
    NSData *wkdata=[NSData dataWithBytes:wcpr length:arg_ed_pt-arg_st_pt];
    NSString *wstr=[[NSString alloc] initWithData:wkdata encoding:NSUTF8StringEncoding];
    long len=[wstr length];
    NSDictionary *ret_val = @{@"type": [NSNumber numberWithInt: (int)arg_type],
                              @"location": [NSNumber numberWithLong:end_input_point],
                              @"length": [NSNumber numberWithLong:len]};
    end_input_point+=len;
    end_regist_point=arg_ed_pt;
    last_input_point=arg_ed_pt;
    return ret_val;
}
// 字句解析
-(NSMutableArray*)html_lex:(NSString*)arg_text {
    const char *arg_cpr=[arg_text UTF8String];
    //long len=strlen(arg_cpr);
    //char *wbuff=(char*)malloc(len);
    end_regist_point=0;
    end_input_point=0;
    last_input_point=end_input_point;
    NSMutableArray *ret_array=[[NSMutableArray alloc] init];
    //NSDate *startDate = [NSDate date];
    const char *wcpr=arg_cpr;
    const char *skpt=arg_cpr;
    long end_leng=strlen(arg_cpr);
    bool tag_start_flag=false;
    bool endtag_start_falg=false;
    while(*wcpr!=(char)NULL) {
        //if ((long)(wcpr-arg_cpr)==158727) {
        //    NSLog(@"%ld", (long)(wcpr-arg_cpr));
        //}
        while(*wcpr!=(char)NULL) {
            if (*wcpr=='\\') {
                wcpr++;
                if (*wcpr==(char)NULL) {
                    break;
                }
                wcpr++;
                continue;
            }
            if ((*wcpr==' ')||(*wcpr=='\n')||(*wcpr=='\t')||(*wcpr=='\r')) {
                wcpr++;
            }else{
                break;
            }
        }
        if (*wcpr==(char)NULL) {
            break;
        }
        if (((end_leng-(long)(wcpr-arg_cpr))>4)&&(strncmp(wcpr, "<!--", 4)==0)) {
            //if ((long)(wcpr-arg_cpr)==239129) {
            //    NSLog(@"-->%ld", (long)(wcpr-arg_cpr));
            //}
            skpt=wcpr;
            while(TRUE) {
                if (*skpt==(char)NULL) {
                    break;
                }
                if (*skpt=='\n') {
                    skpt++;
                    continue;
                }
                if (*skpt=='\\') {
                    skpt++;
                    continue;
                }
                if (*skpt=='"') {
                    while(*skpt!=(char)NULL) {
                        if (*++skpt=='"') {
                            skpt++;
                            break;
                        }else if (*skpt=='\n') {
                            skpt++;
                        }else if (*skpt=='\\') {
                            skpt++;
                        }
                    }
                    continue;
                }
                if (*skpt=='\'') {
                    while(*skpt!=(char)NULL) {
                        if (*++skpt=='\'') {
                            skpt++;
                            break;
                        }else if (*skpt=='\n') {
                            skpt++;
                        }else if (*skpt=='\\') {
                            skpt++;
                        }
                    }
                    continue;
                }
                if (((end_leng-(long)(skpt-arg_cpr))>3)&&(strncmp(skpt, "-->", 3)==0)) {
                    skpt+=3;
                    break;
                }else{
                    skpt++;
                }
            }
            if (wcpr!=skpt) {
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:HtmlCommentType];
                [ret_array addObject:token];
                //NSLog(@"");
            }
            if (*skpt==(char)NULL) {
                break;
            }
            wcpr=skpt;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=3)&&(strncmp(wcpr, "-->", 3)==0)) {
            wcpr+=3;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=2)&&(strncmp(wcpr, "<!", 2)==0)) {
            tag_start_flag=true;
            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+2) type:HtmlDocumentType];
            [ret_array addObject:token];
            wcpr+=2;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=2)&&(strncmp(wcpr, "</", 2)==0)) {
            tag_start_flag=false;
            endtag_start_falg=true;
            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+2) type:EndTagType];
            [ret_array addObject:token];
            wcpr+=2;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=2)&&(strncmp(wcpr, "/>", 2)==0)) {
            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+2) type:TagCloseType];
            [ret_array addObject:token];
            wcpr+=2;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=2)&&(strncmp(wcpr, "<?", 2)==0)) {
            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+2) type:PhpStartTagType];
            [ret_array addObject:token];
            wcpr+=2;
        }else if (((end_leng-(long)(wcpr-arg_cpr))>=2)&&(strncmp(wcpr, "?>", 2)==0)) {
            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+2) type:PhpEndTagType];
            [ret_array addObject:token];
            wcpr+=2;
        }else{
            if (*wcpr=='=') {
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+1) type:EqualType];
                [ret_array addObject:token];
                wcpr++;
            }else if (*wcpr=='<') {
                tag_start_flag=true;
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+1) type:TagStartType];
                [ret_array addObject:token];
                wcpr++;
            }else if (*wcpr=='>') {
                tag_start_flag=false;
                endtag_start_falg=false;
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(wcpr-arg_cpr+1) type:TagEndType];
                [ret_array addObject:token];
                wcpr++;
            }else if (*wcpr=='"') {
                skpt=wcpr;
                while(*skpt!=(char)NULL) {
                    if (*++skpt=='"') {
                        skpt++;
                        break;
                    }else if (*skpt=='\n') {
                        skpt++;
                    }else if (*skpt=='\\') {
                        skpt++;
                    }
                }
                if (*skpt==(char)NULL) {
                    break;
                }
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:DoubleQtType];
                [ret_array addObject:token];
                wcpr=skpt;
            }else if (*wcpr=='\'') {
                skpt=wcpr;
                while(*skpt!=(char)NULL) {
                    if (*++skpt=='\'') {
                        skpt++;
                        break;
                    }else if (*skpt=='\n') {
                        skpt++;
                    }else if (*skpt=='\\') {
                        skpt++;
                    }
                }
                if (*skpt==(char)NULL) {
                    break;
                }
                NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:SingleQtType];
                [ret_array addObject:token];
                wcpr=skpt;
            }else{
                skpt=wcpr;
                while(*skpt!=(char)NULL) {
                    if (*skpt=='\\') {
                        skpt++;
                        continue;
                    }
                    if ((*skpt==' ')||(*skpt=='\n')||(*skpt=='\t')||(*skpt=='\r')||(*skpt=='<')||(*skpt=='>')||(*skpt=='=')||(*skpt=='"')||(*skpt=='\'')) {
                        break;
                    }else{
                        if (((end_leng-(long)(wcpr-skpt))>2)&&(strncmp(skpt, "/>", 2)==0)) {
                            break;
                        }
                        skpt++;
                    }
                }
                if (wcpr!=skpt) {
                    if (tag_start_flag) {
                        NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:TagNameStringType];
                        [ret_array addObject:token];
                        //NSString *term_string=[arg_text substringWithRange:[token rangeValue]];
                        //NSLog(@"%@", term_string);
                        tag_start_flag=false;
                    }else{
                        if (endtag_start_falg) {
                            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:TagEndNameStringType];
                            [ret_array addObject:token];
                        }else{
                            NSDictionary *token=[self createTValue:arg_cpr st_pt:(long)(wcpr-arg_cpr) ed_pt:(long)(skpt-arg_cpr) type:StringType];
                            [ret_array addObject:token];
                        }
                    }
                }
                if (*skpt==(char)NULL) {
                    break;
                }
                wcpr=skpt;
            }
        }
    }
    //NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
    //NSLog(@"time is %lf (sec)", interval);
    return ret_array;
}
@end
