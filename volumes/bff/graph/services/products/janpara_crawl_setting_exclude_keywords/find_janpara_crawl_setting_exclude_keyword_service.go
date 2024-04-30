package janpara_crawl_setting_exclude_keywords

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

type IFindJanparaCrawlSettingExcludeKeywordService interface {
	FindJanparaCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.JanparaCrawlSettingExcludeKeyword, error)
}

type FindJanparaCrawlSettingExcludeKeywordService struct{}

func (f *FindJanparaCrawlSettingExcludeKeywordService) FindJanparaCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.JanparaCrawlSettingExcludeKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch janpara_crawl_setting_exclude_keyword data")
	}

	var response struct {
		ExcludeKeywords []struct {
			ID                    int     `json:"id"`
			JanparaCrawlSettingID int     `json:"janpara_crawl_setting_id"`
			Keyword               *string `json:"keyword"`
			UpdatedAt             string  `json:"updated_at"`
			CreatedAt             string  `json:"created_at"`
		} `json:"janpara_crawl_setting_exclude_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeKeywords := make([]*model.JanparaCrawlSettingExcludeKeyword, len(response.ExcludeKeywords))
	for i, ExcludeKeyword := range response.ExcludeKeywords {
		ExcludeKeywords[i] = &model.JanparaCrawlSettingExcludeKeyword{
			ID:                    strconv.Itoa(ExcludeKeyword.ID),
			JanparaCrawlSettingID: ExcludeKeyword.JanparaCrawlSettingID,
			Keyword:               ExcludeKeyword.Keyword,
			UpdatedAt:             ExcludeKeyword.UpdatedAt,
			CreatedAt:             ExcludeKeyword.CreatedAt,
		}
	}

	return ExcludeKeywords, nil
}
