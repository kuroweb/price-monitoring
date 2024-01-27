package graph

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/yahoo_auction_products"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	ProductService             products.IProductService
	YahooAuctionProductService yahoo_auction_products.IYahooAuctionProductService
}
