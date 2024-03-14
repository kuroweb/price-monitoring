package products

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/calculate_daily_yahoo_auction_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_exclude_keywords"
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
	yahoo_auction_crawl_setting_exclude_keywords.IYahooAuctionCrawlSettingExcludeKeywordService
	calculate_daily_yahoo_auction_products.ICaluculateDailyYahooAuctionProductService
	mercari_products.IMercariProductService
}

type ProductService struct {
	*FindProductService
	*DeleteProductService
	*CreateProductService
	*UpdateProductService
	*yahoo_auction_products.YahooAuctionProductService
	*yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService
	*yahoo_auction_crawl_setting_exclude_keywords.YahooAuctionCrawlSettingExcludeKeywordService
	*calculate_daily_yahoo_auction_products.CaluculateDailyYahooAuctionProductService
	*mercari_products.MercariProductService
}

func New() IProductService {
	return &ProductService{
		FindProductService:                            &FindProductService{},
		DeleteProductService:                          &DeleteProductService{},
		CreateProductService:                          &CreateProductService{},
		UpdateProductService:                          &UpdateProductService{},
		YahooAuctionProductService:                    &yahoo_auction_products.YahooAuctionProductService{},
		YahooAuctionCrawlSettingService:               &yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService{},
		YahooAuctionCrawlSettingExcludeKeywordService: &yahoo_auction_crawl_setting_exclude_keywords.YahooAuctionCrawlSettingExcludeKeywordService{},
		CaluculateDailyYahooAuctionProductService:     &calculate_daily_yahoo_auction_products.CaluculateDailyYahooAuctionProductService{},
		MercariProductService:                         &mercari_products.MercariProductService{},
	}
}
