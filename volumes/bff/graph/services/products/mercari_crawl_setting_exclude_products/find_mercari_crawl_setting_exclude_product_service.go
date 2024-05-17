package mercari_crawl_setting_exclude_products

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

type IFindMercariCrawlSettingExcludeProductService interface {
	FindMercariCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.MercariCrawlSettingExcludeProduct, error)
}

type FindMercariCrawlSettingExcludeProductService struct{}

func (f *FindMercariCrawlSettingExcludeProductService) FindMercariCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.MercariCrawlSettingExcludeProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_exclude_products", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch mercari_crawl_setting_exclude_product data")
	}

	var response struct {
		ExcludeProducts []struct {
			ID                    int    `json:"id"`
			MercariCrawlSettingID int    `json:"mercari_crawl_setting_id"`
			ExternalID            string `json:"external_id"`
			UpdatedAt             string `json:"updated_at"`
			CreatedAt             string `json:"created_at"`
		} `json:"mercari_crawl_setting_exclude_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeProducts := make([]*model.MercariCrawlSettingExcludeProduct, len(response.ExcludeProducts))
	for i, ExcludeProduct := range response.ExcludeProducts {
		ExcludeProducts[i] = &model.MercariCrawlSettingExcludeProduct{
			ID:                    strconv.Itoa(ExcludeProduct.ID),
			MercariCrawlSettingID: ExcludeProduct.MercariCrawlSettingID,
			ExternalID:            ExcludeProduct.ExternalID,
			UpdatedAt:             ExcludeProduct.UpdatedAt,
			CreatedAt:             ExcludeProduct.CreatedAt,
		}
	}

	return ExcludeProducts, nil
}
