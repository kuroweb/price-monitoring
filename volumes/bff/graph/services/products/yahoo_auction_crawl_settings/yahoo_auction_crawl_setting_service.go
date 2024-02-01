package yahoo_auction_crawl_settings

type IYahooAuctionCrawlSettingService interface {
	IFindYahooAuctionCrawlSettingService
}

type YahooAuctionCrawlSettingService struct {
	*FindYahooAuctionCrawlSettingService
}
