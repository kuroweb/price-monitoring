package services

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type yahooAuctionProductService struct{}

func (y *yahooAuctionProductService) GetYahooAuctionProductByID(ctx context.Context, id string) (*model.YahooAuctionProduct, error) {
	url := fmt.Sprintf("http://backend:3000/api/v1/yahoo_auction_products/%s", id)

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
		Price:          response.Price,
		Published:      response.Published,
	}

	return yahooAuctionProduct, nil
}

func (y *yahooAuctionProductService) GetYahooAuctionProductsByParams(ctx context.Context, obj *model.Product, id *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error) {
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

	url := "http://backend:3000/api/v1/yahoo_auction_products?" + params.Encode()

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
			Price:          yahoo_auction_product.Price,
			Published:      yahoo_auction_product.Published,
		}
	}

	return yahoo_auction_products, nil
}
