package janpara_crawl_setting_required_keywords

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

type IFindJanparaCrawlSettingRequiredKeywordService interface {
	FindJanparaCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.JanparaCrawlSettingRequiredKeyword, error)
}

type FindJanparaCrawlSettingRequiredKeywordService struct{}

func (f *FindJanparaCrawlSettingRequiredKeywordService) FindJanparaCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.JanparaCrawlSettingRequiredKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_required_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch janpara_crawl_setting_required_keyword data")
	}

	var response struct {
		RequiredKeywords []struct {
			ID                    int     `json:"id"`
			JanparaCrawlSettingID int     `json:"janpara_crawl_setting_id"`
			Keyword               *string `json:"keyword"`
			UpdatedAt             string  `json:"updated_at"`
			CreatedAt             string  `json:"created_at"`
		} `json:"janpara_crawl_setting_required_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	RequiredKeywords := make([]*model.JanparaCrawlSettingRequiredKeyword, len(response.RequiredKeywords))
	for i, RequiredKeyword := range response.RequiredKeywords {
		RequiredKeywords[i] = &model.JanparaCrawlSettingRequiredKeyword{
			ID:                    strconv.Itoa(RequiredKeyword.ID),
			JanparaCrawlSettingID: RequiredKeyword.JanparaCrawlSettingID,
			Keyword:               RequiredKeyword.Keyword,
			UpdatedAt:             RequiredKeyword.UpdatedAt,
			CreatedAt:             RequiredKeyword.CreatedAt,
		}
	}

	return RequiredKeywords, nil
}
