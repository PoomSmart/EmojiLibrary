#import <Foundation/Foundation.h>

/*
   iOS 5 - 8.2

   PSEmojiCategoryRecent = 0,
   PSEmojiCategoryPeople = 1,
   PSEmojiCategoryNature = 2,
   PSEmojiCategoryObjects = 3,
   PSEmojiCategoryPlaces = 4,
   PSEmojiCategorySymbols = 5

 */

/*
   iOS 8.3 - 8.4

   PSEmojiCategoryRecent = 0,
   PSEmojiCategoryPeople = 1,
   PSEmojiCategoryNature = 2,
   PSEmojiCategoryFoodAndDrink = 3,
   PSEmojiCategoryCelebration = 4,
   PSEmojiCategoryActivity = 5,
   PSEmojiCategoryTravelAndPlaces = 6,
   PSEmojiCategoryObjectsAndSymbols = 7,
   PSEmojiCategoryPrepopulated = 8

 */

/*
   iOS 9.0

   PSEmojiCategoryRecent = 0,
   PSEmojiCategoryPeople = 1,
   PSEmojiCategoryNature = 2,
   PSEmojiCategoryFoodAndDrink = 3,
   PSEmojiCategoryCelebration = 4,
   PSEmojiCategoryActivity = 5,
   PSEmojiCategoryTravelAndPlaces = 6,
   PSEmojiCategoryFlags = 7,
   PSEmojiCategoryObjectsAndSymbols = 8,
   PSEmojiCategoryPrepopulated = 9
 */

// Compatibility
typedef NS_ENUM(NSInteger, IDXPSEmojiCategory) {
    IDXPSEmojiCategoryRecent = 0,
    IDXPSEmojiCategoryPeople = 1,
    IDXPSEmojiCategoryNature = 2,
    IDXPSEmojiCategoryFoodAndDrink = 3,
    IDXPSEmojiCategoryActivity = 4,
    IDXPSEmojiCategoryTravelAndPlaces = 5,
    IDXPSEmojiCategoryObjects = 6,
    IDXPSEmojiCategorySymbols = 7,
    IDXPSEmojiCategoryFlags = 8,
    IDXPSEmojiCategoryPrepopulated = 9
};

// iOS 9.1+
typedef NS_ENUM(NSInteger, PSEmojiCategory) {
    PSEmojiCategoryRecent = 0,
    PSEmojiCategoryPeople = 1,
    PSEmojiCategoryNature = 2,
    PSEmojiCategoryFoodAndDrink = 3,
    PSEmojiCategoryCelebration = 4,
    PSEmojiCategoryActivity = 5,
    PSEmojiCategoryTravelAndPlaces = 6,
    PSEmojiCategoryFlags = 7,
    PSEmojiCategoryObjectsAndSymbols = 8,
    PSEmojiCategoryPrepopulated = 9,
    PSEmojiCategoryObjects = 10,
    PSEmojiCategorySymbols = 11
};

// iOS 9.1+ default category order: 0, 1, 2, 3, 5, 6, 10, 11, 7
