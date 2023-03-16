import Foundation

struct FlashSaleWrapper: Decodable {
    let flashSale: [FlashSale]

    enum CodingKeys: String, CodingKey {
        case flashSale = "flash_sale"
    }
}

// MARK: - FlashSale
struct FlashSale: Decodable {
    let category, name: String
    let price: Double
    let discount: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case category, name, price, discount
        case imageURL = "image_url"
    }
}
