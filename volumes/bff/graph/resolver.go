package graph

import "github.com/kuroweb/price-monitoring/volumes/bff/graph/services"

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	Srv services.Services
}
