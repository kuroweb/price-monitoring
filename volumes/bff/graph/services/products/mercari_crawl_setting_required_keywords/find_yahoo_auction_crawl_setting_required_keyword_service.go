package mercari_crawl_setting_required_keywords

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

type IFindMercariCrawlSettingRequiredKeywordService interface {
	FindMercariCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.MercariCrawlSettingRequiredKeyword, error)
}

type FindMercariCrawlSettingRequiredKeywordService struct{}

func (f *FindMercariCrawlSettingRequiredKeywordService) FindMercariCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.MercariCrawlSettingRequiredKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_required_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch mercari_crawl_setting_required_keyword data")
	}

	var response struct {
		RequiredKeywords []struct {
			ID                    int     `json:"id"`
			MercariCrawlSettingID int     `json:"mercari_crawl_setting_id"`
			Keyword               *string `json:"keyword"`
			UpdatedAt             string  `json:"updated_at"`
			CreatedAt             string  `json:"created_at"`
		} `json:"mercari_crawl_setting_required_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	RequiredKeywords := make([]*model.MercariCrawlSettingRequiredKeyword, len(response.RequiredKeywords))
	for i, RequiredKeyword := range response.RequiredKeywords {
		RequiredKeywords[i] = &model.MercariCrawlSettingRequiredKeyword{
			ID:                    strconv.Itoa(RequiredKeyword.ID),
			MercariCrawlSettingID: RequiredKeyword.MercariCrawlSettingID,
			Keyword:               RequiredKeyword.Keyword,
			UpdatedAt:             RequiredKeyword.UpdatedAt,
			CreatedAt:             RequiredKeyword.CreatedAt,
		}
	}

	return RequiredKeywords, nil
}
