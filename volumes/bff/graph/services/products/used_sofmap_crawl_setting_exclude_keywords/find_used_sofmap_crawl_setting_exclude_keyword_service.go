package used_sofmap_crawl_setting_exclude_keywords

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

type IFindUsedSofmapCrawlSettingExcludeKeywordService interface {
	FindUsedSofmapCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingExcludeKeyword, error)
}

type FindUsedSofmapCrawlSettingExcludeKeywordService struct{}

func (f *FindUsedSofmapCrawlSettingExcludeKeywordService) FindUsedSofmapCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.UsedSofmapCrawlSettingExcludeKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_exclude_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch used_sofmap_crawl_setting_exclude_keyword data")
	}

	var response struct {
		ExcludeKeywords []struct {
			ID                       int     `json:"id"`
			UsedSofmapCrawlSettingID int     `json:"used_sofmap_crawl_setting_id"`
			Keyword                  *string `json:"keyword"`
			UpdatedAt                string  `json:"updated_at"`
			CreatedAt                string  `json:"created_at"`
		} `json:"used_sofmap_crawl_setting_exclude_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeKeywords := make([]*model.UsedSofmapCrawlSettingExcludeKeyword, len(response.ExcludeKeywords))
	for i, ExcludeKeyword := range response.ExcludeKeywords {
		ExcludeKeywords[i] = &model.UsedSofmapCrawlSettingExcludeKeyword{
			ID:                       strconv.Itoa(ExcludeKeyword.ID),
			UsedSofmapCrawlSettingID: ExcludeKeyword.UsedSofmapCrawlSettingID,
			Keyword:                  ExcludeKeyword.Keyword,
			UpdatedAt:                ExcludeKeyword.UpdatedAt,
			CreatedAt:                ExcludeKeyword.CreatedAt,
		}
	}

	return ExcludeKeywords, nil
}
