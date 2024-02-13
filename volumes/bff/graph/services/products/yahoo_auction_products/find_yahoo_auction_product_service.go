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

type IFindYahooAuctionProductService interface {
	FindYahooAuctionProduct(ctx context.Context, id *string, productID *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error)
}

type FindYahooAuctionProductService struct{}

func (f *FindYahooAuctionProductService) FindYahooAuctionProduct(ctx context.Context, id *string, productID *string, yahooAuctionID *string, name *string, price *int, published *bool) ([]*model.YahooAuctionProduct, error) {
	params := make(url.Values)

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
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_products?%s", cfg.BackendUrl, *productID, params.Encode())

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
			Canceled       bool   `json:"canceled"`
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
			Canceled:       yahoo_auction_product.Canceled,
		}
	}

	return yahoo_auction_products, nil
}
