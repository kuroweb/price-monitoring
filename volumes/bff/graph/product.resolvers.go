package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.40

import (
	"context"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
	"github.com/kuroweb/price-monitoring/volumes/bff/internal"
)

// MercariCrawlSettingExcludeKeywords is the resolver for the mercariCrawlSettingExcludeKeywords field.
func (r *mercariCrawlSettingResolver) MercariCrawlSettingExcludeKeywords(ctx context.Context, obj *model.MercariCrawlSetting) ([]*model.MercariCrawlSettingExcludeKeyword, error) {
	return r.ProductService.FindMercariCrawlSettingExcludeKeyword(ctx, obj.ProductID, obj.ID)
}

// MercariCrawlSettingRequiredKeywords is the resolver for the mercariCrawlSettingRequiredKeywords field.
func (r *mercariCrawlSettingResolver) MercariCrawlSettingRequiredKeywords(ctx context.Context, obj *model.MercariCrawlSetting) ([]*model.MercariCrawlSettingRequiredKeyword, error) {
	return r.ProductService.FindMercariCrawlSettingRequiredKeyword(ctx, obj.ProductID, obj.ID)
}

// YahooAuctionProducts is the resolver for the yahooAuctionProducts field.
func (r *productResolver) YahooAuctionProducts(ctx context.Context, obj *model.Product, published *bool, sort *string, order *string) ([]*model.YahooAuctionProduct, error) {
	return r.ProductService.FindYahooAuctionProduct(ctx, nil, &obj.ID, nil, nil, nil, published, sort, order)
}

// YahooAuctionCrawlSetting is the resolver for the yahooAuctionCrawlSetting field.
func (r *productResolver) YahooAuctionCrawlSetting(ctx context.Context, obj *model.Product) (*model.YahooAuctionCrawlSetting, error) {
	return r.ProductService.FindYahooAuctionCrawlSetting(ctx, obj.ID)
}

// YahooAuctionDailyPurchaseSummaries is the resolver for the yahooAuctionDailyPurchaseSummaries field.
func (r *productResolver) YahooAuctionDailyPurchaseSummaries(ctx context.Context, obj *model.Product) ([]*model.YahooAuctionDailyPurchaseSummary, error) {
	return r.ProductService.FindYahooAuctionDailyPurchaseSummary(ctx, obj.ID)
}

// MercariProducts is the resolver for the mercariProducts field.
func (r *productResolver) MercariProducts(ctx context.Context, obj *model.Product, published *bool, sort *string, order *string) ([]*model.MercariProduct, error) {
	return r.ProductService.FindMercariProduct(ctx, nil, &obj.ID, nil, nil, nil, published, sort, order)
}

// MercariCrawlSetting is the resolver for the mercariCrawlSetting field.
func (r *productResolver) MercariCrawlSetting(ctx context.Context, obj *model.Product) (*model.MercariCrawlSetting, error) {
	return r.ProductService.FindMercariCrawlSetting(ctx, obj.ID)
}

// MercariDailyPurchaseSummaries is the resolver for the mercariDailyPurchaseSummaries field.
func (r *productResolver) MercariDailyPurchaseSummaries(ctx context.Context, obj *model.Product) ([]*model.MercariDailyPurchaseSummary, error) {
	return r.ProductService.FindMercariDailyPurchaseSummary(ctx, obj.ID)
}

// RelatedProducts is the resolver for the relatedProducts field.
func (r *productResolver) RelatedProducts(ctx context.Context, obj *model.Product, published *bool, page *int, per *int, sort *string, order *string) ([]*model.RelatedProduct, error) {
	return r.ProductService.FindRelatedProduct(ctx, &obj.ID, nil, nil, nil, published, page, per, sort, order)
}

// YahooAuctionCrawlSettingExcludeKeywords is the resolver for the yahooAuctionCrawlSettingExcludeKeywords field.
func (r *yahooAuctionCrawlSettingResolver) YahooAuctionCrawlSettingExcludeKeywords(ctx context.Context, obj *model.YahooAuctionCrawlSetting) ([]*model.YahooAuctionCrawlSettingExcludeKeyword, error) {
	return r.ProductService.FindYahooAuctionCrawlSettingExcludeKeyword(ctx, obj.ProductID, obj.ID)
}

// YahooAuctionCrawlSettingRequiredKeywords is the resolver for the yahooAuctionCrawlSettingRequiredKeywords field.
func (r *yahooAuctionCrawlSettingResolver) YahooAuctionCrawlSettingRequiredKeywords(ctx context.Context, obj *model.YahooAuctionCrawlSetting) ([]*model.YahooAuctionCrawlSettingRequiredKeyword, error) {
	return r.ProductService.FindYahooAuctionCrawlSettingRequiredKeyword(ctx, obj.ProductID, obj.ID)
}

// MercariCrawlSetting returns internal.MercariCrawlSettingResolver implementation.
func (r *Resolver) MercariCrawlSetting() internal.MercariCrawlSettingResolver {
	return &mercariCrawlSettingResolver{r}
}

// Product returns internal.ProductResolver implementation.
func (r *Resolver) Product() internal.ProductResolver { return &productResolver{r} }

// YahooAuctionCrawlSetting returns internal.YahooAuctionCrawlSettingResolver implementation.
func (r *Resolver) YahooAuctionCrawlSetting() internal.YahooAuctionCrawlSettingResolver {
	return &yahooAuctionCrawlSettingResolver{r}
}

type mercariCrawlSettingResolver struct{ *Resolver }
type productResolver struct{ *Resolver }
type yahooAuctionCrawlSettingResolver struct{ *Resolver }
