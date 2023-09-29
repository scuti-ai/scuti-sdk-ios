//
//  CustomScutiButtonViewController.m
//  ExampleScutiObjC
//
//  Created by mac on 26/09/2023.
//

#import "CustomScutiButtonViewController.h"
@import ScutiSDKSwift;

@interface CustomScutiButtonViewController () <ScutiSDKManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblStoreReady;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAuthenticated;
@property (weak, nonatomic) IBOutlet UILabel *lblCntProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblCntRewards;

@property (weak, nonatomic) IBOutlet UILabel *lblButtonNew;
@property (weak, nonatomic) IBOutlet UILabel *lblButtonNewRewards;

@end

@implementation CustomScutiButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ScutiSDKManager.shared.delegate = self;
    if (ScutiSDKManager.shared.scutiEventsObjC.isStoreReady) {
        self.lblStoreReady.text = @"Store Ready : ON";
        self.lblStoreReady.textColor = UIColor.greenColor;
    }
    if (ScutiSDKManager.shared.scutiEventsObjC.userToken != nil) {
        self.lblUserAuthenticated.text = @"User authenticated : YES";
        self.lblUserAuthenticated.textColor = UIColor.greenColor;
    }
    self.lblCntProducts.text = [NSString stringWithFormat:@"New Products : %ld", (long)ScutiSDKManager.shared.scutiEventsObjC.cntNewProducts];
    if (ScutiSDKManager.shared.scutiEventsObjC.cntNewProducts > 0) {
        [self.lblButtonNew setHidden:false];
        self.lblButtonNew.text = [NSString stringWithFormat:@"New: %ld", (long)ScutiSDKManager.shared.scutiEventsObjC.cntNewProducts];
    }
    self.lblCntRewards.text = [NSString stringWithFormat:@"New Rewards : %ld", (long)ScutiSDKManager.shared.scutiEventsObjC.cntRewards];
    if (ScutiSDKManager.shared.scutiEventsObjC.cntRewards > 0) {
        [self.lblButtonNewRewards setHidden:false];
        self.lblButtonNewRewards.text = [NSString stringWithFormat:@"%ld", (long)ScutiSDKManager.shared.scutiEventsObjC.cntRewards];
    }
}
- (IBAction)onStore:(id)sender {
    [ScutiSDKManager.shared showScutiWebViewWithViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ScutiSDKManagerDelegate

- (void)onBackToGame {
    
}

- (void)onErrorOccurredWithError:(NSError * _Nonnull)error {
    
}

- (void)onLogout {
    self.lblUserAuthenticated.text = @"User authenticated : NO";
    self.lblUserAuthenticated.textColor = UIColor.redColor;
}

- (void)onNewProductsWithCntProducts:(NSInteger)cntProducts {
    self.lblCntProducts.text = [NSString stringWithFormat:@"New Products : %ld", (long)cntProducts];
    [self.lblButtonNew setHidden:cntProducts == 0];
    self.lblButtonNew.text = [NSString stringWithFormat:@"New: %ld", (long)cntProducts];
}

- (void)onNewRewardsWithCntRewards:(NSInteger)cntRewards {
    self.lblCntRewards.text = [NSString stringWithFormat:@"New Rewards : %ld", (long)cntRewards];
    [self.lblButtonNewRewards setHidden:cntRewards == 0];
    self.lblButtonNewRewards.text = [NSString stringWithFormat:@"%ld", (long)cntRewards];
}

- (void)onScutiButtonClicked {
    
}

- (void)onScutiExchangeWithExchange:(ScutiExchangeClass * _Nonnull)exchange {
    
}

- (void)onStoreReady {
    self.lblStoreReady.text = @"Store Ready : ON";
    self.lblStoreReady.textColor = UIColor.greenColor;
}

- (void)onUserTokenWithUserToken:(NSString * _Nonnull)userToken {
    self.lblUserAuthenticated.text = @"User authenticated : YES";
    self.lblUserAuthenticated.textColor = UIColor.greenColor;
}

@end
