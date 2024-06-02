package used_sofmap_crawl_setting_required_keywords

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

type IFindUsedSofmapCrawlSettingRequiredKeywordService interface {
	FindUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingRequiredKeyword, error)
}

type FindUsedSofmapCrawlSettingRequiredKeywordService struct{}

func (f *FindUsedSofmapCrawlSettingRequiredKeywordService) FindUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingRequiredKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_required_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch used_sofmap_crawl_setting_required_keyword data")
	}

	var response struct {
		RequiredKeywords []struct {
			ID                       int     `json:"id"`
			UsedSofmapCrawlSettingID int     `json:"used_sofmap_crawl_setting_id"`
			Keyword                  *string `json:"keyword"`
			UpdatedAt                string  `json:"updated_at"`
			CreatedAt                string  `json:"created_at"`
		} `json:"used_sofmap_crawl_setting_required_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	RequiredKeywords := make([]*model.UsedSofmapCrawlSettingRequiredKeyword, len(response.RequiredKeywords))
	for i, RequiredKeyword := range response.RequiredKeywords {
		RequiredKeywords[i] = &model.UsedSofmapCrawlSettingRequiredKeyword{
			ID:                       strconv.Itoa(RequiredKeyword.ID),
			UsedSofmapCrawlSettingID: RequiredKeyword.UsedSofmapCrawlSettingID,
			Keyword:                  RequiredKeyword.Keyword,
			UpdatedAt:                RequiredKeyword.UpdatedAt,
			CreatedAt:                RequiredKeyword.CreatedAt,
		}
	}

	return RequiredKeywords, nil
}
