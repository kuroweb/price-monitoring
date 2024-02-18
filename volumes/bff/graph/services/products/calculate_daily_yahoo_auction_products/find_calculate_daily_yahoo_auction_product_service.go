package calculate_daily_yahoo_auction_products

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IFindCaluculateDailyYahooAuctionProductService interface {
	FindCalculateDailyYahooAuctionProduct(ctx context.Context, productID string) ([]*model.CalculateDailyYahooAuctionProduct, error)
}

type FindCaluculateDailyYahooAuctionProductService struct{}

func (f *FindCaluculateDailyYahooAuctionProductService) FindCalculateDailyYahooAuctionProduct(ctx context.Context, productID string) ([]*model.CalculateDailyYahooAuctionProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/calculate_daily_yahoo_auction_products", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch calculate_daily_yahoo_auction_product data")
	}

	var response struct {
		CalculateDailyYahooAuctionProducts []struct {
			ID         int    `json:"id"`
			ProductID  int    `json:"product_id"`
			Price      *int   `json:"price"`
			TargetDate string `json:"target_date"`
			UpdatedAt  string `json:"updated_at"`
			CreatedAt  string `json:"created_at"`
		} `json:"calculate_daily_yahoo_auction_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	calculate_daily_yahoo_auction_products := make([]*model.CalculateDailyYahooAuctionProduct, len(response.CalculateDailyYahooAuctionProducts))
	for i, calculate_daily_yahoo_auction_product := range response.CalculateDailyYahooAuctionProducts {
		calculate_daily_yahoo_auction_products[i] = &model.CalculateDailyYahooAuctionProduct{
			ID:         strconv.Itoa(calculate_daily_yahoo_auction_product.ID),
			ProductID:  calculate_daily_yahoo_auction_product.ProductID,
			Price:      calculate_daily_yahoo_auction_product.Price,
			TargetDate: calculate_daily_yahoo_auction_product.TargetDate,
			UpdatedAt:  calculate_daily_yahoo_auction_product.UpdatedAt,
			CreatedAt:  calculate_daily_yahoo_auction_product.CreatedAt,
		}
	}

	return calculate_daily_yahoo_auction_products, nil
}
