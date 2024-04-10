package yahoo_fleamarket_daily_purchase_summaries

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

type IFindYahooFleamarketDailyPurchaseSummaryService interface {
	FindYahooFleamarketDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.YahooFleamarketDailyPurchaseSummary, error)
}

type FindYahooFleamarketDailyPurchaseSummaryService struct{}

func (f *FindYahooFleamarketDailyPurchaseSummaryService) FindYahooFleamarketDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.YahooFleamarketDailyPurchaseSummary, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_fleamarket_daily_purchase_summaries", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch calculate_daily_yahoo_fleamarket_product data")
	}

	var response struct {
		YahooFleamarketDailyPurchaseSummarys []struct {
			ID                   int    `json:"id"`
			ProductID            int    `json:"product_id"`
			AveragePurchasePrice *int   `json:"average_purchase_price"`
			PurchaseCount        int    `json:"purchase_count"`
			Date                 string `json:"date"`
			UpdatedAt            string `json:"updated_at"`
			CreatedAt            string `json:"created_at"`
		} `json:"yahoo_fleamarket_daily_purchase_summaries"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	yahoo_fleamarket_daily_purchase_summaries := make([]*model.YahooFleamarketDailyPurchaseSummary, len(response.YahooFleamarketDailyPurchaseSummarys))
	for i, yahoo_fleamarket_daily_purchase_summary := range response.YahooFleamarketDailyPurchaseSummarys {
		yahoo_fleamarket_daily_purchase_summaries[i] = &model.YahooFleamarketDailyPurchaseSummary{
			ID:                   strconv.Itoa(yahoo_fleamarket_daily_purchase_summary.ID),
			ProductID:            yahoo_fleamarket_daily_purchase_summary.ProductID,
			AveragePurchasePrice: yahoo_fleamarket_daily_purchase_summary.AveragePurchasePrice,
			PurchaseCount:        yahoo_fleamarket_daily_purchase_summary.PurchaseCount,
			Date:                 yahoo_fleamarket_daily_purchase_summary.Date,
			UpdatedAt:            yahoo_fleamarket_daily_purchase_summary.UpdatedAt,
			CreatedAt:            yahoo_fleamarket_daily_purchase_summary.CreatedAt,
		}
	}

	return yahoo_fleamarket_daily_purchase_summaries, nil
}
