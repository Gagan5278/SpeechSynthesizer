//
//  SpeechSynthesizerViewController.h
//  SpeechSynthesizer
//
//  Created by Manish Rawat on 23/05/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DropDownListView.h"
@interface SpeechSynthesizerViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,kDropDownListViewDelegate,UITextFieldDelegate,AVSpeechSynthesizerDelegate>
{
    DropDownListView * Dropobj;
    __weak IBOutlet UIButton *speedButton;
    __weak IBOutlet UIButton *pitchButton;
    NSArray *arryList;
    UIActionSheet *actionSheet;
    __weak IBOutlet UIToolbar *myToolbar;
    __weak IBOutlet UITextField *inputTextField;
}
@property(nonatomic,strong)AVSpeechSynthesizer *synthesizer;
@property(nonatomic,retain)NSString *selectedLanguage;
@property(nonatomic,retain)NSMutableDictionary *dictionaryLanguage;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property(nonatomic,retain)NSMutableArray *arrayLaguageCode;
- (IBAction)PitchButtonPressed:(id)sender;
- (IBAction)SpeedButtonPressed:(id)sender;
- (IBAction)LanguageButtonPressed:(id)sender;
- (IBAction)DoneButtonPressed:(id)sender;
- (IBAction)SpeakButtonPressed:(id)sender;
@end
