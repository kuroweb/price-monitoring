package products

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_products"
)

type IProductService interface {
	IFindProductService
	IDeleteProductService
	ICreateProductService
	IUpdateProductService
	yahoo_auction_products.IYahooAuctionProductService
	yahoo_auction_crawl_settings.IYahooAuctionCrawlSettingService
}

type ProductService struct {
	*FindProductService
	*DeleteProductService
	*CreateProductService
	*UpdateProductService
	*yahoo_auction_products.YahooAuctionProductService
	*yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService
}

func New() IProductService {
	return &ProductService{
		FindProductService:              &FindProductService{},
		DeleteProductService:            &DeleteProductService{},
		CreateProductService:            &CreateProductService{},
		UpdateProductService:            &UpdateProductService{},
		YahooAuctionProductService:      &yahoo_auction_products.YahooAuctionProductService{},
		YahooAuctionCrawlSettingService: &yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService{},
	}
}
