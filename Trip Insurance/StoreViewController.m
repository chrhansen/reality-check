//
//  StoreViewController.m
//  
//
//  Created by Christian Hansen on 13/02/13.
//  Copyright (c) 2013 Christian Hansen. All rights reserved.
//

#import "StoreViewController.h"
#import "MKStoreManager.h"
#import "StoreCell.h"
#import "SKProduct+PriceAsString.h"
#import "MBProgressHUD.h"

@interface StoreViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *restoreButton;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation StoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[MKStoreManager sharedManager] removeAllKeychainData];
    [self _addObservings];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MKStoreManager sharedManager] reloadProducts];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[self purchases] count] == 0) {
        [self.view addSubview:self.progressHUD];
        [self.progressHUD show:NO];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)_addObservings
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsFetched:) name:kProductFetchedNotification object:nil];
}


- (MBProgressHUD *)progressHUD
{
    if (_progressHUD == nil) {
        _progressHUD = [MBProgressHUD.alloc initWithView:self.view];
        _progressHUD.dimBackground = YES;
    }
    return _progressHUD;
}

- (void)buyButtonTapped:(id)sender
{
    [self.progressHUD show:YES];
    NSInteger productIndex = [(UIButton *)sender tag];
    [[MKStoreManager sharedManager] buyFeature:[[self purchases][productIndex] productIdentifier] onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
        [self.progressHUD hide:YES];
        NSAssert([NSThread isMainThread], @"WTF! completion handler not on main thread");
        [self reloadProductWithIdentifier:purchasedFeature];
    } onCancelled:^{
        [self.progressHUD hide:YES];
        NSAssert([NSThread isMainThread], @"WTF! completion handler not on main thread");
    }];
}


- (IBAction)restoreTapped:(id)sender
{
    [self.progressHUD show:YES];
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        NSAssert([NSThread isMainThread], @"WTF! completion handler not on main thread");
        [self.progressHUD hide:YES];
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    } onError:^(NSError *error) {
        NSAssert([NSThread isMainThread], @"WTF! completion handler not on main thread");
        [self.progressHUD hide:YES];
        [self _presentErrorMessage:error.localizedDescription];
    }];
}



- (void)_presentErrorMessage:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark Store updates
- (void)productsFetched:(NSNotification *)notification
{
    [self.progressHUD hide:YES];
    NSNumber *isProductsAvailable = notification.object;
    if (isProductsAvailable.boolValue) {
        [self.collectionView reloadData];
    }
}


- (void)reloadProductWithIdentifier:(NSString *)productIdentifier
{
    if (!productIdentifier) return;
    NSUInteger row = [[self purchases] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        SKProduct *product = (SKProduct *)obj;
        if (product.productIdentifier == productIdentifier) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:0]]];
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *product = [[self purchases] objectAtIndex:indexPath.row];
    StoreCell *storeCell = (StoreCell *)cell;
    storeCell.titleLabel.text = product.localizedTitle;
    storeCell.descriptionLabel.text = product.localizedDescription;
    [storeCell.descriptionLabel sizeToFit];
    if ([MKStoreManager isFeaturePurchased:product.productIdentifier]) {
        [storeCell.buyButton setTitle:NSLocalizedString(@"Purchased", nil) forState:UIControlStateNormal];
        [storeCell.buyButton setEnabled:NO];
    } else {
        [storeCell.buyButton setTitle:product.priceAsString forState:UIControlStateNormal];
        storeCell.buyButton.tag = indexPath.row;
        [storeCell.buyButton setEnabled:YES];
        if (storeCell.buyButton.allTargets.count == 0) {
            [storeCell.buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    storeCell.mainImageView.image = [self imageForProductIdentifier:product.productIdentifier];
}


- (UIImage *)imageForProductIdentifier:(NSString *)productIdentifier
{
    UIImage *image;
    if ([productIdentifier isEqualToString:@"PremiumReality"]) {
        image = [UIImage imageNamed:@"premium-reality"];
    } 
    return image;
}


- (NSArray *)purchases
{
    return [[[MKStoreManager sharedManager] purchasableObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SKProduct *product1 = (SKProduct *)obj1;
        SKProduct *product2 = (SKProduct *)obj2;
        return [product2.productIdentifier compare:product1.productIdentifier];
    }];
}

- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self purchases] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Store Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell) [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
