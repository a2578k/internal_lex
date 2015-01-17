//
//  ShowDataViewController.h
//  LexSample
//
//  Created by SogawaSeiji on 2015/01/17.
//  Copyright (c) 2015年 LoftLabo. All rights reserved.
//

#import <UIKit/UIKit.h>

enum TokenType {
    StringType,
    TagStartType,         // <
    TagEndType,           // >
    EndTagType,           // </
    TagCloseType,         // />
    DoubleQtType,         // "
    SingleQtType,         // '
    SpaceType,
    EqualType,            // =
    HtmlCommentType,      // <!--
    HtmlDocumentType,     // <!
    JavaScriptType,       //
    CssScriptType,        //
    PhpCommentType,       // //
    PhpStartTagType,      // <?
    PhpEndTagType,        // ?>
    TagNameStringType,    //
    TagEndNameStringType,
    PhpValueType,
    ReturnType,
    DkSpareteType,
    SemicolonType,         // ;
    ColonType,             // :
    CssCommentType,        // /* */
    CssTagName,
    IncrementType,         // ++
    DecrementType,         // --
    StrictEqualType,
    ConditionType,
    CommaType,
    DotType,
    OperationType,
    SquareBracketType,
    CurlyBracketsStartType,// {
    CurlyBracketsEndType,// }
    ParenthesisStartType,
    ParenthesisEndType,
    HtmlInJavaScriptType,
    HtmlInCssType,
    JavaScriptCmdType,
    JavaScriptFunctionType,
    JavaScriptNewType,
    JavaScriptCommentType
};

@interface ShowDataViewController : UIViewController {
    IBOutlet UITextView *text_view;
    NSString *url_str;
    long end_regist_point;
    long end_input_point;
    long last_input_point;
}
@property (strong, nonatomic) NSString *url_str;
-(NSMutableArray*)html_lex:(NSString*)arg_tex;
@end
