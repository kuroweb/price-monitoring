package mercari_daily_purchase_summaries

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

type IFindMercariDailyPurchaseSummaryService interface {
	FindMercariDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.MercariDailyPurchaseSummary, error)
}

type FindMercariDailyPurchaseSummaryService struct{}

func (f *FindMercariDailyPurchaseSummaryService) FindMercariDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.MercariDailyPurchaseSummary, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_daily_purchase_summaries", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch calculate_daily_mercari_product data")
	}

	var response struct {
		MercariDailyPurchaseSummarys []struct {
			ID                   int    `json:"id"`
			ProductID            int    `json:"product_id"`
			AveragePurchasePrice *int   `json:"average_purchase_price"`
			PurchaseCount        int    `json:"purchase_count"`
			Date                 string `json:"date"`
			UpdatedAt            string `json:"updated_at"`
			CreatedAt            string `json:"created_at"`
		} `json:"mercari_daily_purchase_summaries"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	mercari_daily_purchase_summaries := make([]*model.MercariDailyPurchaseSummary, len(response.MercariDailyPurchaseSummarys))
	for i, mercari_daily_purchase_summary := range response.MercariDailyPurchaseSummarys {
		mercari_daily_purchase_summaries[i] = &model.MercariDailyPurchaseSummary{
			ID:                   strconv.Itoa(mercari_daily_purchase_summary.ID),
			ProductID:            mercari_daily_purchase_summary.ProductID,
			AveragePurchasePrice: mercari_daily_purchase_summary.AveragePurchasePrice,
			PurchaseCount:        mercari_daily_purchase_summary.PurchaseCount,
			Date:                 mercari_daily_purchase_summary.Date,
			UpdatedAt:            mercari_daily_purchase_summary.UpdatedAt,
			CreatedAt:            mercari_daily_purchase_summary.CreatedAt,
		}
	}

	return mercari_daily_purchase_summaries, nil
}
