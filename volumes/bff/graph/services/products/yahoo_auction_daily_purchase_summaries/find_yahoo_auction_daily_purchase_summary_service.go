package yahoo_auction_daily_purchase_summaries

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

type IFindYahooAuctionDailyPurchaseSummaryService interface {
	FindYahooAuctionDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.YahooAuctionDailyPurchaseSummary, error)
}

type FindYahooAuctionDailyPurchaseSummaryService struct{}

func (f *FindYahooAuctionDailyPurchaseSummaryService) FindYahooAuctionDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.YahooAuctionDailyPurchaseSummary, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_daily_purchase_summaries", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch calculate_daily_yahoo_auction_product data")
	}

	var response struct {
		YahooAuctionDailyPurchaseSummarys []struct {
			ID                   int    `json:"id"`
			ProductID            int    `json:"product_id"`
			AveragePurchasePrice *int   `json:"average_purchase_price"`
			PurchaseCount        int    `json:"purchase_count"`
			Date                 string `json:"date"`
			UpdatedAt            string `json:"updated_at"`
			CreatedAt            string `json:"created_at"`
		} `json:"yahoo_auction_daily_purchase_summaries"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	yahoo_auction_daily_purchase_summaries := make([]*model.YahooAuctionDailyPurchaseSummary, len(response.YahooAuctionDailyPurchaseSummarys))
	for i, yahoo_auction_daily_purchase_summary := range response.YahooAuctionDailyPurchaseSummarys {
		yahoo_auction_daily_purchase_summaries[i] = &model.YahooAuctionDailyPurchaseSummary{
			ID:                   strconv.Itoa(yahoo_auction_daily_purchase_summary.ID),
			ProductID:            yahoo_auction_daily_purchase_summary.ProductID,
			AveragePurchasePrice: yahoo_auction_daily_purchase_summary.AveragePurchasePrice,
			PurchaseCount:        yahoo_auction_daily_purchase_summary.PurchaseCount,
			Date:                 yahoo_auction_daily_purchase_summary.Date,
			UpdatedAt:            yahoo_auction_daily_purchase_summary.UpdatedAt,
			CreatedAt:            yahoo_auction_daily_purchase_summary.CreatedAt,
		}
	}

	return yahoo_auction_daily_purchase_summaries, nil
}
