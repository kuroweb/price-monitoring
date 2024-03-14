package mercari_products

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

type IFindMercariProductService interface {
	FindMercariProduct(ctx context.Context, id *string, productID *string, mercariID *string, name *string, price *int, published *bool) ([]*model.MercariProduct, error)
}

type FindMercariProductService struct{}

func (f *FindMercariProductService) FindMercariProduct(ctx context.Context, id *string, productID *string, mercariID *string, name *string, price *int, published *bool) ([]*model.MercariProduct, error) {
	params := make(url.Values)

	if id != nil {
		params.Set("id", *id)
	}

	if mercariID != nil {
		params.Set("yahoo_auction_id", *mercariID)
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

	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_products?%s", cfg.BackendUrl, *productID, params.Encode())

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch yahoo_auction_product data")
	}

	var response struct {
		MercariProducts []struct {
			ID           int     `json:"id"`
			MercariId    string  `json:"yahoo_auction_id"`
			Name         string  `json:"name"`
			ThumbnailURL string  `json:"thumbnail_url"`
			Price        int     `json:"price"`
			Published    bool    `json:"published"`
			BoughtDate   *string `json:"bought_date"`
			CreatedAt    string  `json:"created_at"`
			UpdatedAt    string  `json:"updated_at"`
		} `json:"yahoo_auction_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	yahoo_auction_products := make([]*model.MercariProduct, len(response.MercariProducts))
	for i, yahoo_auction_product := range response.MercariProducts {
		yahoo_auction_products[i] = &model.MercariProduct{
			ID:           strconv.Itoa(yahoo_auction_product.ID),
			MercariID:    yahoo_auction_product.MercariId,
			Name:         yahoo_auction_product.Name,
			ThumbnailURL: yahoo_auction_product.ThumbnailURL,
			Price:        yahoo_auction_product.Price,
			Published:    yahoo_auction_product.Published,
			BoughtDate:   yahoo_auction_product.BoughtDate,
			CreatedAt:    yahoo_auction_product.CreatedAt,
			UpdatedAt:    yahoo_auction_product.UpdatedAt,
		}
	}

	return yahoo_auction_products, nil
}
