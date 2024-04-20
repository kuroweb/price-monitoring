package related_products

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IFindRelatedProductService interface {
	FindRelatedProduct(ctx context.Context, productID *string, platformMask string, published bool, yahooAuctionBuyable bool, page *int, per *int, sort *string, order *string) ([]*model.RelatedProduct, error)
}

type FindRelatedProductService struct{}

func (f *FindRelatedProductService) FindRelatedProduct(ctx context.Context, productID *string, platformMask string, published bool, yahooAuctionBuyable bool, page *int, per *int, sort *string, order *string) ([]*model.RelatedProduct, error) {
	params := make(url.Values)

	params.Set("platform_mask", platformMask)
	params.Set("published", strconv.FormatBool(published))
	params.Set("yahoo_auction_buyable", strconv.FormatBool(yahooAuctionBuyable))

	if page != nil {
		params.Set("page", strconv.Itoa(*page))
	}

	if per != nil {
		params.Set("per", strconv.Itoa(*per))
	}

	if sort != nil {
		params.Set("sort", *sort)
	}

	if order != nil {
		params.Set("order", *order)
	}

	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/related_products?%s", cfg.BackendUrl, *productID, params.Encode())

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch related_product data")
	}

	var response struct {
		RelatedProducts []struct {
			Platform     string  `json:"platform"`
			ProductID    int     `json:"product_id"`
			ExternalID   string  `json:"external_id"`
			Name         string  `json:"name"`
			ThumbnailURL string  `json:"thumbnail_url"`
			Price        int     `json:"price"`
			BuyoutPrice  *int    `json:"buyout_price"`
			Published    bool    `json:"published"`
			BoughtDate   *string `json:"bought_date"`
			EndDate      *string `json:"end_date"`
			CreatedAt    string  `json:"created_at"`
			UpdatedAt    string  `json:"updated_at"`
		} `json:"related_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	related_products := make([]*model.RelatedProduct, len(response.RelatedProducts))
	for i, related_product := range response.RelatedProducts {
		related_products[i] = &model.RelatedProduct{
			Platform:     related_product.Platform,
			ProductID:    related_product.ProductID,
			ExternalID:   related_product.ExternalID,
			Name:         related_product.Name,
			ThumbnailURL: related_product.ThumbnailURL,
			Price:        related_product.Price,
			BuyoutPrice:  related_product.BuyoutPrice,
			Published:    related_product.Published,
			BoughtDate:   related_product.BoughtDate,
			EndDate:      related_product.EndDate,
			CreatedAt:    related_product.CreatedAt,
			UpdatedAt:    related_product.UpdatedAt,
		}
	}

	return related_products, nil
}
