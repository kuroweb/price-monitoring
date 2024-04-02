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
	FindRelatedProduct(ctx context.Context, productID *string, externalID *string, name *string, price *int, published *bool, page *int, per *int, sort *string, order *string) ([]*model.RelatedProduct, error)
}

type FindRelatedProductService struct{}

func (f *FindRelatedProductService) FindRelatedProduct(ctx context.Context, productID *string, externalID *string, name *string, price *int, published *bool, page *int, per *int, sort *string, order *string) ([]*model.RelatedProduct, error) {
	params := make(url.Values)

	if externalID != nil {
		params.Set("related_id", *externalID)
	}

	if name != nil {
		params.Set("name", *name)
	}

	if price != nil {
		params.Set("price", strconv.Itoa(*price))
	}

	if published != nil {
		params.Set("published", strconv.FormatBool(*published))
	}

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
			ProductID    int     `json:"product_id"`
			ExternalID   string  `json:"external_id"`
			Name         string  `json:"name"`
			ThumbnailURL string  `json:"thumbnail_url"`
			Price        int     `json:"price"`
			Published    bool    `json:"published"`
			BoughtDate   *string `json:"bought_date"`
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
			ProductID:    related_product.ProductID,
			ExternalID:   related_product.ExternalID,
			Name:         related_product.Name,
			ThumbnailURL: related_product.ThumbnailURL,
			Price:        related_product.Price,
			Published:    related_product.Published,
			BoughtDate:   related_product.BoughtDate,
			CreatedAt:    related_product.CreatedAt,
			UpdatedAt:    related_product.UpdatedAt,
		}
	}

	return related_products, nil
}
