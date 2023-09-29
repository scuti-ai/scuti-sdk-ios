//
//  ManualViewController.m
//  ExampleScutiObjC
//
//  Created by mac on 26/09/2023.
//

#import "ManualViewController.h"
@import ScutiSDKSwift;

@interface ManualViewController () <ScutiSDKManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblStoreReady;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAuthenticated;
@property (weak, nonatomic) IBOutlet UILabel *lblCntProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblCntRewards;

@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ScutiButton * scutiButtonView = [[ScutiButton alloc] initWithFrame:CGRectZero];
    scutiButtonView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:scutiButtonView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.view.safeAreaLayoutGuide.trailingAnchor constraintEqualToAnchor:scutiButtonView.trailingAnchor constant:10],
        [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:scutiButtonView.bottomAnchor constant:40],
        [scutiButtonView.widthAnchor constraintEqualToConstant:260],
        [scutiButtonView.heightAnchor constraintEqualToConstant:90]
    ]];
    
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
    self.lblCntRewards.text = [NSString stringWithFormat:@"New Rewards : %ld", (long)ScutiSDKManager.shared.scutiEventsObjC.cntRewards];
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
}

- (void)onNewRewardsWithCntRewards:(NSInteger)cntRewards {
    self.lblCntRewards.text = [NSString stringWithFormat:@"New Rewards : %ld", (long)cntRewards];
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
