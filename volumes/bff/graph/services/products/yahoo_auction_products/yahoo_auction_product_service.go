package yahoo_auction_products

type IYahooAuctionProductService interface {
	IFindYahooAuctionProductService
}

type YahooAuctionProductService struct {
	*FindYahooAuctionProductService
}

func New() IYahooAuctionProductService {
	return &YahooAuctionProductService{
		FindYahooAuctionProductService: &FindYahooAuctionProductService{},
	}
}
