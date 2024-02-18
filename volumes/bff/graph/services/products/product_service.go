package products

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/calculate_daily_yahoo_auction_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_exclude_conditions"
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
	yahoo_auction_crawl_setting_exclude_conditions.IYahooAuctionCrawlSettingExcludeConditionService
	calculate_daily_yahoo_auction_products.ICaluculateDailyYahooAuctionProductService
}

type ProductService struct {
	*FindProductService
	*DeleteProductService
	*CreateProductService
	*UpdateProductService
	*yahoo_auction_products.YahooAuctionProductService
	*yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService
	*yahoo_auction_crawl_setting_exclude_conditions.YahooAuctionCrawlSettingExcludeConditionService
	*calculate_daily_yahoo_auction_products.CaluculateDailyYahooAuctionProductService
}

func New() IProductService {
	return &ProductService{
		FindProductService:                              &FindProductService{},
		DeleteProductService:                            &DeleteProductService{},
		CreateProductService:                            &CreateProductService{},
		UpdateProductService:                            &UpdateProductService{},
		YahooAuctionProductService:                      &yahoo_auction_products.YahooAuctionProductService{},
		YahooAuctionCrawlSettingService:                 &yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService{},
		YahooAuctionCrawlSettingExcludeConditionService: &yahoo_auction_crawl_setting_exclude_conditions.YahooAuctionCrawlSettingExcludeConditionService{},
		CaluculateDailyYahooAuctionProductService:       &calculate_daily_yahoo_auction_products.CaluculateDailyYahooAuctionProductService{},
	}
}
