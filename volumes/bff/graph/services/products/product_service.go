package products

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/iosys_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/iosys_crawl_setting_exclude_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/iosys_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/iosys_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/janpara_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/janpara_crawl_setting_exclude_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/janpara_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/janpara_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_setting_exclude_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_daily_purchase_summaries"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/mercari_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/pc_koubou_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/pc_koubou_crawl_setting_exclude_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/pc_koubou_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/pc_koubou_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/related_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_exclude_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_exclude_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_setting_required_keywords"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_crawl_settings"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_daily_purchase_summaries"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_auction_products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products/yahoo_fleamarket_daily_purchase_summaries"
)

type IProductService interface {
	IFindProductService
	IDeleteProductService
	ICreateProductService
	IUpdateProductService
	yahoo_auction_products.IYahooAuctionProductService
	yahoo_auction_crawl_settings.IYahooAuctionCrawlSettingService
	yahoo_auction_crawl_setting_exclude_keywords.IYahooAuctionCrawlSettingExcludeKeywordService
	yahoo_auction_crawl_setting_exclude_products.IYahooAuctionCrawlSettingExcludeProductService
	yahoo_auction_crawl_setting_required_keywords.IYahooAuctionCrawlSettingRequiredKeywordService
	yahoo_auction_daily_purchase_summaries.IFindYahooAuctionDailyPurchaseSummaryService
	yahoo_fleamarket_daily_purchase_summaries.IFindYahooFleamarketDailyPurchaseSummaryService
	mercari_products.IMercariProductService
	mercari_crawl_settings.IMercariCrawlSettingService
	mercari_crawl_setting_exclude_keywords.IMercariCrawlSettingExcludeKeywordService
	mercari_crawl_setting_exclude_products.IMercariCrawlSettingExcludeProductService
	mercari_crawl_setting_required_keywords.IMercariCrawlSettingRequiredKeywordService
	mercari_daily_purchase_summaries.IMercariDailyPurchaseSummaryService
	janpara_crawl_settings.IJanparaCrawlSettingService
	janpara_crawl_setting_exclude_keywords.IJanparaCrawlSettingExcludeKeywordService
	janpara_crawl_setting_exclude_products.IJanparaCrawlSettingExcludeProductService
	janpara_crawl_setting_required_keywords.IJanparaCrawlSettingRequiredKeywordService
	iosys_crawl_settings.IIosysCrawlSettingService
	iosys_crawl_setting_exclude_keywords.IIosysCrawlSettingExcludeKeywordService
	iosys_crawl_setting_exclude_products.IIosysCrawlSettingExcludeProductService
	iosys_crawl_setting_required_keywords.IIosysCrawlSettingRequiredKeywordService
	pc_koubou_crawl_settings.IPcKoubouCrawlSettingService
	pc_koubou_crawl_setting_exclude_keywords.IPcKoubouCrawlSettingExcludeKeywordService
	pc_koubou_crawl_setting_exclude_products.IPcKoubouCrawlSettingExcludeProductService
	pc_koubou_crawl_setting_required_keywords.IPcKoubouCrawlSettingRequiredKeywordService
	related_products.IRelatedProductService
}

type ProductService struct {
	*FindProductService
	*DeleteProductService
	*CreateProductService
	*UpdateProductService
	*yahoo_auction_products.YahooAuctionProductService
	*yahoo_auction_crawl_settings.YahooAuctionCrawlSettingService
	*yahoo_auction_crawl_setting_exclude_keywords.YahooAuctionCrawlSettingExcludeKeywordService
	*yahoo_auction_crawl_setting_exclude_products.YahooAuctionCrawlSettingExcludeProductService
	*yahoo_auction_crawl_setting_required_keywords.YahooAuctionCrawlSettingRequiredKeywordService
	*yahoo_auction_daily_purchase_summaries.FindYahooAuctionDailyPurchaseSummaryService
	*yahoo_fleamarket_daily_purchase_summaries.FindYahooFleamarketDailyPurchaseSummaryService
	*mercari_products.MercariProductService
	*mercari_crawl_settings.MercariCrawlSettingService
	*mercari_crawl_setting_exclude_keywords.MercariCrawlSettingExcludeKeywordService
	*mercari_crawl_setting_exclude_products.MercariCrawlSettingExcludeProductService
	*mercari_crawl_setting_required_keywords.MercariCrawlSettingRequiredKeywordService
	*mercari_daily_purchase_summaries.MercariDailyPurchaseSummaryService
	*janpara_crawl_settings.JanparaCrawlSettingService
	*janpara_crawl_setting_exclude_keywords.JanparaCrawlSettingExcludeKeywordService
	*janpara_crawl_setting_exclude_products.JanparaCrawlSettingExcludeProductService
	*janpara_crawl_setting_required_keywords.JanparaCrawlSettingRequiredKeywordService
	*iosys_crawl_settings.IosysCrawlSettingService
	*iosys_crawl_setting_exclude_keywords.IosysCrawlSettingExcludeKeywordService
	*iosys_crawl_setting_exclude_products.IosysCrawlSettingExcludeProductService
	*iosys_crawl_setting_required_keywords.IosysCrawlSettingRequiredKeywordService
	*pc_koubou_crawl_settings.PcKoubouCrawlSettingService
	*pc_koubou_crawl_setting_exclude_keywords.PcKoubouCrawlSettingExcludeKeywordService
	*pc_koubou_crawl_setting_exclude_products.PcKoubouCrawlSettingExcludeProductService
	*pc_koubou_crawl_setting_required_keywords.PcKoubouCrawlSettingRequiredKeywordService
	*related_products.RelatedProductService
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
		YahooAuctionCrawlSettingExcludeProductService:  &yahoo_auction_crawl_setting_exclude_products.YahooAuctionCrawlSettingExcludeProductService{},
		YahooAuctionCrawlSettingRequiredKeywordService: &yahoo_auction_crawl_setting_required_keywords.YahooAuctionCrawlSettingRequiredKeywordService{},
		FindYahooAuctionDailyPurchaseSummaryService:    &yahoo_auction_daily_purchase_summaries.FindYahooAuctionDailyPurchaseSummaryService{},
		FindYahooFleamarketDailyPurchaseSummaryService: &yahoo_fleamarket_daily_purchase_summaries.FindYahooFleamarketDailyPurchaseSummaryService{},
		MercariProductService:                          &mercari_products.MercariProductService{},
		MercariCrawlSettingService:                     &mercari_crawl_settings.MercariCrawlSettingService{},
		MercariCrawlSettingExcludeKeywordService:       &mercari_crawl_setting_exclude_keywords.MercariCrawlSettingExcludeKeywordService{},
		MercariCrawlSettingExcludeProductService:       &mercari_crawl_setting_exclude_products.MercariCrawlSettingExcludeProductService{},
		MercariCrawlSettingRequiredKeywordService:      &mercari_crawl_setting_required_keywords.MercariCrawlSettingRequiredKeywordService{},
		MercariDailyPurchaseSummaryService:             &mercari_daily_purchase_summaries.MercariDailyPurchaseSummaryService{},
		JanparaCrawlSettingService:                     &janpara_crawl_settings.JanparaCrawlSettingService{},
		JanparaCrawlSettingExcludeKeywordService:       &janpara_crawl_setting_exclude_keywords.JanparaCrawlSettingExcludeKeywordService{},
		JanparaCrawlSettingExcludeProductService:       &janpara_crawl_setting_exclude_products.JanparaCrawlSettingExcludeProductService{},
		JanparaCrawlSettingRequiredKeywordService:      &janpara_crawl_setting_required_keywords.JanparaCrawlSettingRequiredKeywordService{},
		IosysCrawlSettingService:                       &iosys_crawl_settings.IosysCrawlSettingService{},
		IosysCrawlSettingExcludeKeywordService:         &iosys_crawl_setting_exclude_keywords.IosysCrawlSettingExcludeKeywordService{},
		IosysCrawlSettingExcludeProductService:         &iosys_crawl_setting_exclude_products.IosysCrawlSettingExcludeProductService{},
		IosysCrawlSettingRequiredKeywordService:        &iosys_crawl_setting_required_keywords.IosysCrawlSettingRequiredKeywordService{},
		PcKoubouCrawlSettingService:                    &pc_koubou_crawl_settings.PcKoubouCrawlSettingService{},
		PcKoubouCrawlSettingExcludeKeywordService:      &pc_koubou_crawl_setting_exclude_keywords.PcKoubouCrawlSettingExcludeKeywordService{},
		PcKoubouCrawlSettingExcludeProductService:      &pc_koubou_crawl_setting_exclude_products.PcKoubouCrawlSettingExcludeProductService{},
		PcKoubouCrawlSettingRequiredKeywordService:     &pc_koubou_crawl_setting_required_keywords.PcKoubouCrawlSettingRequiredKeywordService{},
		RelatedProductService:                          &related_products.RelatedProductService{},
	}
}
