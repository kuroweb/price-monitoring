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
		params.Set("mercari_id", *mercariID)
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
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_products?%s", cfg.BackendUrl, *productID, params.Encode())

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch mercari_product data")
	}

	var response struct {
		MercariProducts []struct {
			ID           int     `json:"id"`
			MercariId    string  `json:"mercari_id"`
			Name         string  `json:"name"`
			ThumbnailURL string  `json:"thumbnail_url"`
			Price        int     `json:"price"`
			Published    bool    `json:"published"`
			BoughtDate   *string `json:"bought_date"`
			CreatedAt    string  `json:"created_at"`
			UpdatedAt    string  `json:"updated_at"`
		} `json:"mercari_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	mercari_products := make([]*model.MercariProduct, len(response.MercariProducts))
	for i, mercari_product := range response.MercariProducts {
		mercari_products[i] = &model.MercariProduct{
			ID:           strconv.Itoa(mercari_product.ID),
			MercariID:    mercari_product.MercariId,
			Name:         mercari_product.Name,
			ThumbnailURL: mercari_product.ThumbnailURL,
			Price:        mercari_product.Price,
			Published:    mercari_product.Published,
			BoughtDate:   mercari_product.BoughtDate,
			CreatedAt:    mercari_product.CreatedAt,
			UpdatedAt:    mercari_product.UpdatedAt,
		}
	}

	return mercari_products, nil
}
