package janpara_crawl_settings

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

type IFindJanparaCrawlSettingService interface {
	FindJanparaCrawlSetting(ctx context.Context, productID string) (*model.JanparaCrawlSetting, error)
}

type FindJanparaCrawlSettingService struct{}

func (f *FindJanparaCrawlSettingService) FindJanparaCrawlSetting(ctx context.Context, productID string) (*model.JanparaCrawlSetting, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings", cfg.BackendUrl, productID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch janpara_crawl_setting data")
	}

	var response struct {
		ID        int    `json:"id"`
		ProductId int    `json:"product_id"`
		Keyword   string `json:"keyword"`
		MinPrice  int    `json:"min_price"`
		MaxPrice  int    `json:"max_price"`
		Enabled   bool   `json:"enabled"`
		CreatedAt string `json:"created_at"`
		UpdatedAt string `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	janparaCrawlSetting := &model.JanparaCrawlSetting{
		ID:        strconv.Itoa(response.ID),
		ProductID: response.ProductId,
		Keyword:   response.Keyword,
		MinPrice:  response.MinPrice,
		MaxPrice:  response.MaxPrice,
		Enabled:   response.Enabled,
		CreatedAt: response.CreatedAt,
		UpdatedAt: response.UpdatedAt,
	}

	return janparaCrawlSetting, nil
}
