import UIKit

enum Resources {
    
    enum identefiers {
        static let goodsCollectViewCell = "goodsCell"
        static let categoryCollectViewCell = "categoryCell"
        static let flashSaleCollectViewCell = "flashSaleCell"
        static let collectionHeader = "collectHeader"
    }
    
    enum UserDefault {
        static let isEnteredKey = "isEntered"
    }
    
    enum Links {
        static let latest = "https://run.mocky.io/v3/cc0071a1-f06e-48fa-9e90-b1c2a61eaca7"
        static let flashSale = "https://run.mocky.io/v3/a9ceeb6e-416d-4352-bde6-2203416576ac"
        static let words = "https://run.mocky.io/v3/4c9cd822-9479-4509-803d-63197e5a9e19"
        static let detailGoods = "https://run.mocky.io/v3/f7f99d04-4971-45d5-92e0-70333383c239"
    }
    
    enum Placaholders {
        static let mainTopSearchBar = "What are you looking for?"
    }
    
    enum CoreData {
        static let coreDataName = "Data"
        static let userEntity = "User"
    }
    
    enum CornerRadius {
        static let textFieldSignIn = 15.0
        static let buttonCornerSignIn = 16.0
    }
    
    enum Fonts {
        static let loginTopLabel = 28.0
        static let textFieldSignIn = 18.0
    }
    
    enum Colors {
        static let mainColor = "mainColor"
        static let mainBackgrSearch = "mainBackgrSearch"
        static let selectedTabBar = "tabbarSelectedColor"
        static let gradientDarkGrey = UIColor(red: 239/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        static let gradientLightGrey = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
    }
    
    enum Titles {
        static let error = "Error"
        static let confirmAlertActionTitle = "OK"
        static let signIn = "Sign in"
        static let lastName = "Last name"
        static let firstName = "First name"
        static let email = "Email"
        static let login = "Log in"
        static let loginTextInSignIn = "Already have an accout?"
        static let signInWithGoogle = "Sign in with Google"
        static let signInWithApple = "Sign in with Apple"
        static let password = "Password"
        static let welcomeBack = "Welcome back"
        static let emailValidateError = "The email isnt correct!"
        static let emailUniqueError = "Ooops, somebody with this email has been registered, try another one!"
        static let loginError = "The user not found, try again!"
        static let viewAll = "View all"
        static let location = "Location"
        static let mainTopText = "Trade by bata"
        static let phones = "Phones"
        static let headphones = "Headphones"
        static let games = "Games"
        static let cars = "Cars"
        static let furniture = "Furniture"
        static let kids = "Kids"
        static let latestSection = "Latest"
        static let flashSaleSection = "Flash sale"
    }
    
    enum Images {
        static let google = "google"
        static let apple = "apple"
        static let eye = "eye"
        static let notEye = "eye.slash"
        static let burgerMenu = "text.justify"
        static let house = "house"
        static let heart = "heart"
        static let cart = "cart"
        static let commentLeft = "bubble.left"
        static let person = "person"
        static let magnifier = "magnifyingglass"
        static let phones = "iphone"
        static let headphones = "headphones"
        static let games = "games"
        static let cars = "cars"
        static let furniture = "furniture"
        static let kids = "kids"
        static let plusFilled = "plusFilled"
        static let plusFilledX2 = "plusFilledX2"
        static let customHeart = "customHeart"
        static let profileCustom = "profileCustom"
        static let chevronDown = "chevron.down"
    }
}
