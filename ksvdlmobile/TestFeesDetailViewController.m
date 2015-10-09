//
//  TestFeesDetailViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 10/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//


#if !defined(StringOrEmpty)
#define StringOrEmpty(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })
#endif

#import "TestFeesDetailViewController.h"
#import "SWRevealViewController.h"

@implementation TestFeesDetailViewController

- (void) viewDidLoad {
    
    [self.menubarButton setTarget: self.revealViewController];
    [self.menubarButton setAction: @selector( rightRevealToggle:)];
    
//    self.TestNameLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"TestName"]);
//    
//    self.SectionLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"Section"]);
//    self.SpecimenLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"Specimens"]);
//    self.SpeciesLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"Species"]);
//    self.PriceLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"Pricing"]);
//    self.SampleContrainerLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"SampleContainer"]);
//    self.ShippingPreserveLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"ShippingPreserve"]);
//    self.DaysTestedLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"DaysTested"]);
//
//    self.EstimatedTurnaroundLabel.text=StringOrEmpty([self.testFeesDetailDict objectForKey:@"EstimatedTurnaround"]);

    self.TestNameLabel.text=[self.testFeesDetailDict objectForKey:@"TestName"]?:@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"Section"]==(id)[NSNull null]))
        self.SectionLabel.text=[self.testFeesDetailDict objectForKey:@"Section"];
    else
        self.SectionLabel.text=@"";
    
    
    if (!([self.testFeesDetailDict objectForKey:@"Specimens"]==(id)[NSNull null]))
        self.SpecimenLabel.text=[self.testFeesDetailDict objectForKey:@"Specimens"];
    else
        self.SpecimenLabel.text=@"";

    if (!([self.testFeesDetailDict objectForKey:@"Species"]==(id)[NSNull null]))
        self.SpeciesLabel.text=[self.testFeesDetailDict objectForKey:@"Species"];
    else
        self.SpeciesLabel.text=@"";

    if (!([self.testFeesDetailDict objectForKey:@"Pricing"]==(id)[NSNull null]))
        self.PriceLabel.text=[self.testFeesDetailDict objectForKey:@"Pricing"];
    else
        self.PriceLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"SampleContainer"]==(id)[NSNull null]))
      self.SampleContrainerLabel.text=[self.testFeesDetailDict objectForKey:@"SampleContainer"];
    else
        self.SampleContrainerLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"ShippingPreserve"]==(id)[NSNull null]))
        self.ShippingPreserveLabel.text=[self.testFeesDetailDict objectForKey:@"ShippingPreserve"];
    else
        self.ShippingPreserveLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"DaysTested"]==(id)[NSNull null]))
        self.DaysTestedLabel.text=[self.testFeesDetailDict objectForKey:@"DaysTested"];
    else
        self.DaysTestedLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"EstimatedTurnaround"]==(id)[NSNull null]))
        self.EstimatedTurnaroundLabel.text=[self.testFeesDetailDict objectForKey:@"EstimatedTurnaround"];
    else
        self.EstimatedTurnaroundLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"TestComments"]==(id)[NSNull null]))
        self.TestCommentsLabel.text=[self.testFeesDetailDict objectForKey:@"TestComments"];
    else
        self.TestCommentsLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"Procedures"]==(id)[NSNull null]))
        self.ProcedureLabel.text=[self.testFeesDetailDict objectForKey:@"Procedures"];
    else
        self.ProcedureLabel.text=@"";

    if (!([self.testFeesDetailDict objectForKey:@"DeliveryMethod"]==(id)[NSNull null]))
        self.DeliveryMethodLabel.text=[self.testFeesDetailDict objectForKey:@"DeliveryMethod"];
    else
        self.DeliveryMethodLabel.text=@"";
    
    if (!([self.testFeesDetailDict objectForKey:@"SectionGroup"]==(id)[NSNull null]))
        self.SectionGroupLabel.text=[self.testFeesDetailDict objectForKey:@"SectionGroup"];
    else
        self.SectionGroupLabel.text=@"";
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


@end
