package janpara_daily_purchase_summaries

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

type IFindJanparaDailyPurchaseSummaryService interface {
	FindJanparaDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.JanparaDailyPurchaseSummary, error)
}

type FindJanparaDailyPurchaseSummaryService struct{}

func (f *FindJanparaDailyPurchaseSummaryService) FindJanparaDailyPurchaseSummary(ctx context.Context, productID string) ([]*model.JanparaDailyPurchaseSummary, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_daily_purchase_summaries", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch calculate_daily_janpara_product data")
	}

	var response struct {
		JanparaDailyPurchaseSummarys []struct {
			ID                   int    `json:"id"`
			ProductID            int    `json:"product_id"`
			AveragePurchasePrice *int   `json:"average_purchase_price"`
			PurchaseCount        int    `json:"purchase_count"`
			Date                 string `json:"date"`
			UpdatedAt            string `json:"updated_at"`
			CreatedAt            string `json:"created_at"`
		} `json:"janpara_daily_purchase_summaries"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	janpara_daily_purchase_summaries := make([]*model.JanparaDailyPurchaseSummary, len(response.JanparaDailyPurchaseSummarys))
	for i, janpara_daily_purchase_summary := range response.JanparaDailyPurchaseSummarys {
		janpara_daily_purchase_summaries[i] = &model.JanparaDailyPurchaseSummary{
			ID:                   strconv.Itoa(janpara_daily_purchase_summary.ID),
			ProductID:            janpara_daily_purchase_summary.ProductID,
			AveragePurchasePrice: janpara_daily_purchase_summary.AveragePurchasePrice,
			PurchaseCount:        janpara_daily_purchase_summary.PurchaseCount,
			Date:                 janpara_daily_purchase_summary.Date,
			UpdatedAt:            janpara_daily_purchase_summary.UpdatedAt,
			CreatedAt:            janpara_daily_purchase_summary.CreatedAt,
		}
	}

	return janpara_daily_purchase_summaries, nil
}
