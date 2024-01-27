package yahoo_auction_products

type IYahooAuctionProductService interface {
	IFindService
}

type YahooAuctionProductService struct {
	*FindService
}

func New() IYahooAuctionProductService {
	return &YahooAuctionProductService{
		FindService: &FindService{},
	}
}
