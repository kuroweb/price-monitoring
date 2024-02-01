package graph

import (
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services/products"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	ProductService products.IProductService
}
