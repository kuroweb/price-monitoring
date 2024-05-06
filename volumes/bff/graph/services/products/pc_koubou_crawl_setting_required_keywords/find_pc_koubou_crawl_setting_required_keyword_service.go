package pc_koubou_crawl_setting_required_keywords

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

type IFindPcKoubouCrawlSettingRequiredKeywordService interface {
	FindPcKoubouCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingRequiredKeyword, error)
}

type FindPcKoubouCrawlSettingRequiredKeywordService struct{}

func (f *FindPcKoubouCrawlSettingRequiredKeywordService) FindPcKoubouCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingRequiredKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_required_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch pc_koubou_crawl_setting_required_keyword data")
	}

	var response struct {
		RequiredKeywords []struct {
			ID                     int     `json:"id"`
			PcKoubouCrawlSettingID int     `json:"pc_koubou_crawl_setting_id"`
			Keyword                *string `json:"keyword"`
			UpdatedAt              string  `json:"updated_at"`
			CreatedAt              string  `json:"created_at"`
		} `json:"pc_koubou_crawl_setting_required_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	RequiredKeywords := make([]*model.PcKoubouCrawlSettingRequiredKeyword, len(response.RequiredKeywords))
	for i, RequiredKeyword := range response.RequiredKeywords {
		RequiredKeywords[i] = &model.PcKoubouCrawlSettingRequiredKeyword{
			ID:                     strconv.Itoa(RequiredKeyword.ID),
			PcKoubouCrawlSettingID: RequiredKeyword.PcKoubouCrawlSettingID,
			Keyword:                RequiredKeyword.Keyword,
			UpdatedAt:              RequiredKeyword.UpdatedAt,
			CreatedAt:              RequiredKeyword.CreatedAt,
		}
	}

	return RequiredKeywords, nil
}
