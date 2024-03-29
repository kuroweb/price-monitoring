package products

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_daily_purchase_summaries"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_daily_purchase_summaries"
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
	yahoo_auction_crawl_setting_required_keywords.IYahooAuctionCrawlSettingRequiredKeywordService
	yahoo_auction_daily_purchase_summaries.IFindYahooAuctionDailyPurchaseSummaryService
	mercari_products.IMercariProductService
	mercari_crawl_settings.IMercariCrawlSettingService
	mercari_crawl_setting_exclude_keywords.IMercariCrawlSettingExcludeKeywordService
	mercari_crawl_setting_required_keywords.IMercariCrawlSettingRequiredKeywordService
	mercari_daily_purchase_summaries.IMercariDailyPurchaseSummaryService
}

type ProductService struct {
	*FindProductService
	*DeleteProductService
	*CreateProductService
	*UpdateProductService
	*yahoo_auction_products.YahooAuctionProductService
	*yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService
	*yahoo_auction_crawl_setting_exclude_keywords.YahooAuctionCrawlSettingExcludeKeywordService
	*yahoo_auction_crawl_setting_required_keywords.YahooAuctionCrawlSettingRequiredKeywordService
	*yahoo_auction_daily_purchase_summaries.FindYahooAuctionDailyPurchaseSummaryService
	*mercari_products.MercariProductService
	*mercari_crawl_settings.MercariCrawlSettingService
	*mercari_crawl_setting_exclude_keywords.MercariCrawlSettingExcludeKeywordService
	*mercari_crawl_setting_required_keywords.MercariCrawlSettingRequiredKeywordService
	*mercari_daily_purchase_summaries.MercariDailyPurchaseSummaryService
}

func New() IProductService {
	return &ProductService{
		FindProductService:                             &FindProductService{},
		DeleteProductService:                           &DeleteProductService{},
		CreateProductService:                           &CreateProductService{},
		UpdateProductService:                           &UpdateProductService{},
		YahooAuctionProductService:                     &yahoo_auction_products.YahooAuctionProductService{},
		YahooAuctionCrawlSettingService:                &yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService{},
		YahooAuctionCrawlSettingExcludeKeywordService:  &yahoo_auction_crawl_setting_exclude_keywords.YahooAuctionCrawlSettingExcludeKeywordService{},
		YahooAuctionCrawlSettingRequiredKeywordService: &yahoo_auction_crawl_setting_required_keywords.YahooAuctionCrawlSettingRequiredKeywordService{},
		FindYahooAuctionDailyPurchaseSummaryService:    &yahoo_auction_daily_purchase_summaries.FindYahooAuctionDailyPurchaseSummaryService{},
		MercariProductService:                          &mercari_products.MercariProductService{},
		MercariCrawlSettingService:                     &mercari_crawl_settings.MercariCrawlSettingService{},
		MercariCrawlSettingExcludeKeywordService:       &mercari_crawl_setting_exclude_keywords.MercariCrawlSettingExcludeKeywordService{},
		MercariCrawlSettingRequiredKeywordService:      &mercari_crawl_setting_required_keywords.MercariCrawlSettingRequiredKeywordService{},
		MercariDailyPurchaseSummaryService:             &mercari_daily_purchase_summaries.MercariDailyPurchaseSummaryService{},
	}
}
