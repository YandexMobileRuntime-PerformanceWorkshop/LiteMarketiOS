import Foundation

// MARK: - Product API Routes
struct ProductRoutes {
    
    // MARK: - Get Products List with Pagination
    static func getProductsList(page: Int = 1, perPage: Int = 100) -> APIRoute<ProductListResponse> {
        var route = APIRoute<ProductListResponse>(decoder: ProductListResponseDecoder())
        route.routeURL = "api/products"
        route.method = .get
        route.parameters = [
            "page": page,
            "per_page": perPage
        ]
        route.encoding = URLEncoding()
        return route
    }
    
    // MARK: - Get Single Product Details
    static func getProductDetail(id: String) -> APIRoute<ProductDetailResponse> {
        var route = APIRoute<ProductDetailResponse>(decoder: ProductDetailResponseDecoder())
        route.routeURL = "api/product/\(id)"
        route.method = .get
        route.needAuthorization = false
        return route
    }
} 
