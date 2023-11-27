package services

import (
	"context"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type Services interface {
	ProductService
	YahooAuctionProductService
}

type ProductService interface {
	GetProductByID(ctx context.Context, id string) (*model.Product, error)
	GetProductsByParams(ctx context.Context, id *string, name *string) ([]*model.Product, error)
}

type YahooAuctionProductService interface {
	GetYahooAuctionProductByID(ctx context.Context, id string) (*model.YahooAuctionProduct, error)
	GetYahooAuctionProductsByParams(ctx context.Context, obj *model.Product, id *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error)
}

type services struct {
	*productService
	*yahooAuctionProductService
}

func New() Services {
	return &services{
		productService:             &productService{},
		yahooAuctionProductService: &yahooAuctionProductService{},
	}
}
