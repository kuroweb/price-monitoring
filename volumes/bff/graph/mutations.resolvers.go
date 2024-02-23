package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.40

import (
	"context"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
	"github.com/kuroweb/price-monitoring/volumes/bff/internal"
)

// CreateProduct is the resolver for the createProduct field.
func (r *mutationResolver) CreateProduct(ctx context.Context, input model.CreateProductInput) (model.CreateProductResult, error) {
	return r.ProductService.CreateProduct(ctx, input)
}

// UpdateProduct is the resolver for the updateProduct field.
func (r *mutationResolver) UpdateProduct(ctx context.Context, id string, input model.UpdateProductInput) (model.UpdateProductResult, error) {
	return r.ProductService.UpdateProduct(ctx, id, input)
}

// DeleteProduct is the resolver for the deleteProduct field.
func (r *mutationResolver) DeleteProduct(ctx context.Context, id string) (model.DeleteProductResult, error) {
	return r.ProductService.DeleteProductById(ctx, id)
}

// CreateYahooAuctionCrawlSettingExcludeCondition is the resolver for the createYahooAuctionCrawlSettingExcludeCondition field.
func (r *mutationResolver) CreateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.CreateYahooAuctionCrawlSettingExcludeConditionInput) (model.CreateYahooAuctionCrawlSettingExcludeConditionResult, error) {
	return r.ProductService.CreateYahooAuctionCrawlSettingExcludeCondition(ctx, input)
}

// UpdateYahooAuctionCrawlSettingExcludeCondition is the resolver for the updateYahooAuctionCrawlSettingExcludeCondition field.
func (r *mutationResolver) UpdateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.UpdateYahooAuctionCrawlSettingExcludeConditionInput) (model.UpdateYahooAuctionCrawlSettingExcludeConditionResult, error) {
	return r.ProductService.UpdateYahooAuctionCrawlSettingExcludeCondition(ctx, input)
}

// DeleteYahooAuctionCrawlSettingExcludeCondition is the resolver for the DeleteYahooAuctionCrawlSettingExcludeCondition field.
func (r *mutationResolver) DeleteYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeConditionResult, error) {
	return r.ProductService.DeleteYahooAuctionCrawlSettingExcludeCondition(ctx, id, productID)
}

// Mutation returns internal.MutationResolver implementation.
func (r *Resolver) Mutation() internal.MutationResolver { return &mutationResolver{r} }

type mutationResolver struct{ *Resolver }
