package services

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

type productService struct{}

func (p *productService) GetProductByID(ctx context.Context, id string) (*model.Product, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s", cfg.BackendUrl, id)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("Failed to fetch product data")
	}

	var response struct {
		ID   int    `json:"id"`
		Name string `json:"name"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	product := &model.Product{
		ID:   strconv.Itoa(response.ID),
		Name: response.Name,
	}

	return product, nil
}

func (p *productService) GetProductsByParams(ctx context.Context, id *string, name *string) ([]*model.Product, error) {
	params := make(url.Values)

	if id != nil {
		params.Set("id", *id)
	}

	if name != nil {
		params.Set("name", *name)
	}

	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products?%s", cfg.BackendUrl, params.Encode())

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("Failed to fetch product data")
	}

	var response struct {
		Products []struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		} `json:"products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	products := make([]*model.Product, len(response.Products))
	for i, product := range response.Products {
		products[i] = &model.Product{
			ID:   strconv.Itoa(product.ID),
			Name: product.Name,
		}
	}

	return products, nil
}
