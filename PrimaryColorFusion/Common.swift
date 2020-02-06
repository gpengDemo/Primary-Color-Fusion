import UIKit


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height


let isiPhoneX = screenHeight >= 812.0

let safeAreaTopHeight:CGFloat = (isiPhoneX && UIDevice.current.model == "iPhone" ? 44 : 20)
let safeAreaBottomHeight:CGFloat = (isiPhoneX && UIDevice.current.model == "iPhone"  ? 30 : 0)


let contentWidth = screenWidth - 18 - 18 
let contentHeight  = screenHeight - 43 - 43 - safeAreaTopHeight - safeAreaBottomHeight


let navigationBarAddTopSafeAreaHeight : CGFloat = (screenHeight >= 812.0) ? 88 : 64

let gameHeight = (screenHeight * 550                                                                                                                                                                   ) / 667 - navigationBarAddTopSafeAreaHeight - 23 - 20 - 20



