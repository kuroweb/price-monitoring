package used_sofmap_crawl_setting_exclude_products

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

type IFindUsedSofmapCrawlSettingExcludeProductService interface {
	FindUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingExcludeProduct, error)
}

type FindUsedSofmapCrawlSettingExcludeProductService struct{}

func (f *FindUsedSofmapCrawlSettingExcludeProductService) FindUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingExcludeProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_exclude_products", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch used_sofmap_crawl_setting_exclude_product data")
	}

	var response struct {
		ExcludeProducts []struct {
			ID                       int    `json:"id"`
			UsedSofmapCrawlSettingID int    `json:"used_sofmap_crawl_setting_id"`
			ExternalID               string `json:"external_id"`
			UpdatedAt                string `json:"updated_at"`
			CreatedAt                string `json:"created_at"`
		} `json:"used_sofmap_crawl_setting_exclude_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeProducts := make([]*model.UsedSofmapCrawlSettingExcludeProduct, len(response.ExcludeProducts))
	for i, ExcludeProduct := range response.ExcludeProducts {
		ExcludeProducts[i] = &model.UsedSofmapCrawlSettingExcludeProduct{
			ID:                       strconv.Itoa(ExcludeProduct.ID),
			UsedSofmapCrawlSettingID: ExcludeProduct.UsedSofmapCrawlSettingID,
			ExternalID:               ExcludeProduct.ExternalID,
			UpdatedAt:                ExcludeProduct.UpdatedAt,
			CreatedAt:                ExcludeProduct.CreatedAt,
		}
	}

	return ExcludeProducts, nil
}
