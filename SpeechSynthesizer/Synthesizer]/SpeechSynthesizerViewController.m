//
//  SpeechSynthesizerViewController.m
//  SpeechSynthesizer
//
//  Created by Gagan on 23/05/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import "SpeechSynthesizerViewController.h"

@interface SpeechSynthesizerViewController ()

@end

@implementation SpeechSynthesizerViewController
@synthesize dictionaryLanguage;
@synthesize arrayLaguageCode;
@synthesize selectedLanguage;
@synthesize synthesizer;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dictionaryLanguage=[NSMutableDictionary dictionary];
    self.arrayLaguageCode=[NSMutableArray array];
    [self performSelectorInBackground:@selector(CreateLanguageDictiuonaryAndCoutryCode) withObject:nil];
    self.selectedLanguage=@"";
}


//- (AVSpeechSynthesizer *)synthesizer
//{
//    if (!synthesizer)
//    {
//        synthesizer = [[AVSpeechSynthesizer alloc] init];
//        synthesizer.delegate = self;
//    }
//    return synthesizer;
//}



-(void)CreateLanguageDictiuonaryAndCoutryCode
{
    NSArray *voiceArr=[AVSpeechSynthesisVoice speechVoices];
    NSArray *laguages=[voiceArr valueForKey:@"language"];
    NSLocale *curLocale=[NSLocale autoupdatingCurrentLocale];
    for(NSString *coutryCode in laguages)
    {
        self.dictionaryLanguage[coutryCode]=[curLocale displayNameForKey:NSLocaleIdentifier value:coutryCode];
    }
    self.arrayLaguageCode=(NSMutableArray*)[self.dictionaryLanguage keysSortedByValueUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}

#pragma mark-pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrayLaguageCode.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *code=[self.arrayLaguageCode objectAtIndex:row];
    NSString *languge=[self.dictionaryLanguage valueForKey:code];
    return languge;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedLanguage = [self.arrayLaguageCode objectAtIndex:row];
   // [[NSUserDefaults standardUserDefaults] setObject:self.selectedLanguage forKey:UYLPrefKeySelectedLanguage];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark-dropdownlist delegate
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    [Dropobj SetBackGroundDropDwon_R:0.0 G:108.0 B:194.0 alpha:0.70];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
   if( [dropdownListView._kTitleText isEqualToString:@"Select Pitch"])
   {
       [pitchButton setTitle:[arryList objectAtIndex:anIndex] forState:UIControlStateNormal];
   }
   else{
       [speedButton setTitle:[arryList objectAtIndex:anIndex] forState:UIControlStateNormal];
   }
}

- (void)DropDownListViewDidCancel{
    
}

#pragma mark-textField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)PitchButtonPressed:(id)sender {
    arryList=[NSArray arrayWithObjects:@"Low",@"Normal",@"High", nil];
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Pitch" withOption:arryList xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:NO];
}

- (IBAction)SpeedButtonPressed:(id)sender {
    arryList=[NSArray arrayWithObjects:@"0.25",@"0.50",@"0.75",@"1.0", nil];
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Speed" withOption:arryList xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:NO];
}

- (IBAction)LanguageButtonPressed:(id)sender {
    self.myPickerView.delegate=self;
    self.myPickerView.dataSource=self;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    myToolbar.frame=CGRectMake(0, 352-44, 320, 44);
    self.myPickerView.frame=CGRectMake(0, 352, 320, 216);
    [UIView commitAnimations];
}

- (IBAction)DoneButtonPressed:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    myToolbar.frame=CGRectMake(0, 568, 320, 44);
    self.myPickerView.frame=CGRectMake(0, 568+44, 320, 216);
    [UIView commitAnimations];
}

- (IBAction)SpeakButtonPressed:(id)sender {
    if(!self.synthesizer.isSpeaking && inputTextField.text.length && self.selectedLanguage)
    {
        AVSpeechSynthesisVoice *voice=[AVSpeechSynthesisVoice voiceWithLanguage:self.selectedLanguage];
        AVSpeechUtterance *utterance=[[AVSpeechUtterance alloc]initWithString:inputTextField.text];
        utterance.voice=voice;
        float rate=AVSpeechUtteranceDefaultSpeechRate * [[speedButton currentTitle] floatValue];
        if(rate>AVSpeechUtteranceMaximumSpeechRate)
        {
            rate=AVSpeechUtteranceMaximumSpeechRate;
        }
        else if(rate<AVSpeechUtteranceMinimumSpeechRate)
        {
            rate=AVSpeechUtteranceMinimumSpeechRate;
        }
        utterance.rate=rate;
        utterance.pitchMultiplier=[self pitchModifier];
        [self.synthesizer speakUtterance:utterance];
    }
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:inputTextField.text];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:characterRange];
    inputTextField.attributedText = text;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSAttributedString *atrStr=[[NSAttributedString alloc]initWithString:inputTextField.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:atrStr];
    [text removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [text length])];
   inputTextField.attributedText = text;
}

- (float)pitchModifier
{
    float pitch = 1.0;
    if([pitchButton.titleLabel.text isEqualToString:@"High"])
    {
        pitch = 0.75;
    }
    else if([pitchButton.titleLabel.text isEqualToString:@"Normal"])
    {
        pitch = 1.0;
    }
    else{
        pitch = 1.0;
    }
    return pitch;
}



@end
