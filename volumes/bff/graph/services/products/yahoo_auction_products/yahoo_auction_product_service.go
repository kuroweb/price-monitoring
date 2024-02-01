package yahoo_auction_products

type IYahooAuctionProductService interface {
	IFindYahooAuctionProductService
}

type YahooAuctionProductService struct {
	*FindYahooAuctionProductService
}
