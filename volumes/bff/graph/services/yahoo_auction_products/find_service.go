package yahoo_auction_products

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

type IFindService interface {
	FindById(ctx context.Context, id string) (*model.YahooAuctionProduct, error)
	FindByParams(ctx context.Context, obj *model.Product, id *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error)
}

type FindService struct{}

func (f *FindService) FindById(ctx context.Context, id string) (*model.YahooAuctionProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/yahoo_auction_products/%s", cfg.BackendUrl, id)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("Failed to fetch yahoo_auction_product data")
	}

	var response struct {
		ID             int    `json:"id"`
		YahooAuctionId string `json:"yahoo_auction_id"`
		Name           string `json:"name"`
		ThumbnailURL   string `json:"thumbnail_url"`
		Price          int    `json:"price"`
		Published      bool   `json:"published"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	yahooAuctionProduct := &model.YahooAuctionProduct{
		ID:             strconv.Itoa(response.ID),
		YahooAuctionID: response.YahooAuctionId,
		Name:           response.Name,
		ThumbnailURL:   response.ThumbnailURL,
		Price:          response.Price,
		Published:      response.Published,
	}

	return yahooAuctionProduct, nil
}

func (f *FindService) FindByParams(ctx context.Context, obj *model.Product, id *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error) {
	params := make(url.Values)

	params.Set("product_id", obj.ID)

	if id != nil {
		params.Set("id", *id)
	}

	if yahooAuctionID != nil {
		params.Set("yahoo_auction_id", *yahooAuctionID)
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
	url := fmt.Sprintf("%s/api/v1/yahoo_auction_products?%s", cfg.BackendUrl, params.Encode())

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("Failed to fetch yahoo_auction_product data")
	}

	var response struct {
		YahooAuctionProducts []struct {
			ID             int    `json:"id"`
			YahooAuctionId string `json:"yahoo_auction_id"`
			Name           string `json:"name"`
			ThumbnailURL   string `json:"thumbnail_url"`
			Price          int    `json:"price"`
			Published      bool   `json:"published"`
		} `json:"yahoo_auction_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	yahoo_auction_products := make([]*model.YahooAuctionProduct, len(response.YahooAuctionProducts))
	for i, yahoo_auction_product := range response.YahooAuctionProducts {
		yahoo_auction_products[i] = &model.YahooAuctionProduct{
			ID:             strconv.Itoa(yahoo_auction_product.ID),
			YahooAuctionID: yahoo_auction_product.YahooAuctionId,
			Name:           yahoo_auction_product.Name,
			ThumbnailURL:   yahoo_auction_product.ThumbnailURL,
			Price:          yahoo_auction_product.Price,
			Published:      yahoo_auction_product.Published,
		}
	}

	return yahoo_auction_products, nil
}
