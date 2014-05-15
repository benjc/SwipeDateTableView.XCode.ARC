//
//  SDCollectionViewController.h
//  SwipeDateTableViewProject
//
//  Created by Benji on 09/05/2014.
//  Copyright (c) 2014 BC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCollectionViewCell.h"

@interface SDCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, SDCollectionViewCellDelegate>

@end