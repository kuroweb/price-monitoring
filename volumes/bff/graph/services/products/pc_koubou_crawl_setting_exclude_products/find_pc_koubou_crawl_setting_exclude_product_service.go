package pc_koubou_crawl_setting_exclude_products

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

type IFindPcKoubouCrawlSettingExcludeProductService interface {
	FindPcKoubouCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingExcludeProduct, error)
}

type FindPcKoubouCrawlSettingExcludeProductService struct{}

func (f *FindPcKoubouCrawlSettingExcludeProductService) FindPcKoubouCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingExcludeProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_products", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch pc_koubou_crawl_setting_exclude_product data")
	}

	var response struct {
		ExcludeProducts []struct {
			ID                     int    `json:"id"`
			PcKoubouCrawlSettingID int    `json:"pc_koubou_crawl_setting_id"`
			ExternalID             string `json:"external_id"`
			UpdatedAt              string `json:"updated_at"`
			CreatedAt              string `json:"created_at"`
		} `json:"pc_koubou_crawl_setting_exclude_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeProducts := make([]*model.PcKoubouCrawlSettingExcludeProduct, len(response.ExcludeProducts))
	for i, ExcludeProduct := range response.ExcludeProducts {
		ExcludeProducts[i] = &model.PcKoubouCrawlSettingExcludeProduct{
			ID:                     strconv.Itoa(ExcludeProduct.ID),
			PcKoubouCrawlSettingID: ExcludeProduct.PcKoubouCrawlSettingID,
			ExternalID:             ExcludeProduct.ExternalID,
			UpdatedAt:              ExcludeProduct.UpdatedAt,
			CreatedAt:              ExcludeProduct.CreatedAt,
		}
	}

	return ExcludeProducts, nil
}
