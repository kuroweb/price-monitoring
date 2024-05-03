package iosys_crawl_setting_exclude_keywords

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

type IFindIosysCrawlSettingExcludeKeywordService interface {
	FindIosysCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.IosysCrawlSettingExcludeKeyword, error)
}

type FindIosysCrawlSettingExcludeKeywordService struct{}

func (f *FindIosysCrawlSettingExcludeKeywordService) FindIosysCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.IosysCrawlSettingExcludeKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch iosys_crawl_setting_exclude_keyword data")
	}

	var response struct {
		ExcludeKeywords []struct {
			ID                  int     `json:"id"`
			IosysCrawlSettingID int     `json:"iosys_crawl_setting_id"`
			Keyword             *string `json:"keyword"`
			UpdatedAt           string  `json:"updated_at"`
			CreatedAt           string  `json:"created_at"`
		} `json:"iosys_crawl_setting_exclude_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeKeywords := make([]*model.IosysCrawlSettingExcludeKeyword, len(response.ExcludeKeywords))
	for i, ExcludeKeyword := range response.ExcludeKeywords {
		ExcludeKeywords[i] = &model.IosysCrawlSettingExcludeKeyword{
			ID:                  strconv.Itoa(ExcludeKeyword.ID),
			IosysCrawlSettingID: ExcludeKeyword.IosysCrawlSettingID,
			Keyword:             ExcludeKeyword.Keyword,
			UpdatedAt:           ExcludeKeyword.UpdatedAt,
			CreatedAt:           ExcludeKeyword.CreatedAt,
		}
	}

	return ExcludeKeywords, nil
}
