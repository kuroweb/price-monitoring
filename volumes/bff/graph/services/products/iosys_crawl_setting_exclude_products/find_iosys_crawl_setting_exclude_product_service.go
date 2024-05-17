package iosys_crawl_setting_exclude_products

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

type IFindIosysCrawlSettingExcludeProductService interface {
	FindIosysCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.IosysCrawlSettingExcludeProduct, error)
}

type FindIosysCrawlSettingExcludeProductService struct{}

func (f *FindIosysCrawlSettingExcludeProductService) FindIosysCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.IosysCrawlSettingExcludeProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_products", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch iosys_crawl_setting_exclude_product data")
	}

	var response struct {
		ExcludeProducts []struct {
			ID                  int    `json:"id"`
			IosysCrawlSettingID int    `json:"iosys_crawl_setting_id"`
			ExternalID          string `json:"external_id"`
			UpdatedAt           string `json:"updated_at"`
			CreatedAt           string `json:"created_at"`
		} `json:"iosys_crawl_setting_exclude_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeProducts := make([]*model.IosysCrawlSettingExcludeProduct, len(response.ExcludeProducts))
	for i, ExcludeProduct := range response.ExcludeProducts {
		ExcludeProducts[i] = &model.IosysCrawlSettingExcludeProduct{
			ID:                  strconv.Itoa(ExcludeProduct.ID),
			IosysCrawlSettingID: ExcludeProduct.IosysCrawlSettingID,
			ExternalID:          ExcludeProduct.ExternalID,
			UpdatedAt:           ExcludeProduct.UpdatedAt,
			CreatedAt:           ExcludeProduct.CreatedAt,
		}
	}

	return ExcludeProducts, nil
}
