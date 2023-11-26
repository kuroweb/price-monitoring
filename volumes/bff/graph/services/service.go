package services

import (
	"context"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type Services interface {
	ProductService
}

type ProductService interface {
	GetProductByID(ctx context.Context, id string) (*model.Product, error)
	GetProductsByParams(ctx context.Context, id *string, name *string) ([]*model.Product, error)
}
