package pc_koubou_crawl_setting_exclude_keywords

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

type IFindPcKoubouCrawlSettingExcludeKeywordService interface {
	FindPcKoubouCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingExcludeKeyword, error)
}

type FindPcKoubouCrawlSettingExcludeKeywordService struct{}

func (f *FindPcKoubouCrawlSettingExcludeKeywordService) FindPcKoubouCrawlSettingExcludeKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.PcKoubouCrawlSettingExcludeKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch pc_koubou_crawl_setting_exclude_keyword data")
	}

	var response struct {
		ExcludeKeywords []struct {
			ID                     int     `json:"id"`
			PcKoubouCrawlSettingID int     `json:"pc_koubou_crawl_setting_id"`
			Keyword                *string `json:"keyword"`
			UpdatedAt              string  `json:"updated_at"`
			CreatedAt              string  `json:"created_at"`
		} `json:"pc_koubou_crawl_setting_exclude_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeKeywords := make([]*model.PcKoubouCrawlSettingExcludeKeyword, len(response.ExcludeKeywords))
	for i, ExcludeKeyword := range response.ExcludeKeywords {
		ExcludeKeywords[i] = &model.PcKoubouCrawlSettingExcludeKeyword{
			ID:                     strconv.Itoa(ExcludeKeyword.ID),
			PcKoubouCrawlSettingID: ExcludeKeyword.PcKoubouCrawlSettingID,
			Keyword:                ExcludeKeyword.Keyword,
			UpdatedAt:              ExcludeKeyword.UpdatedAt,
			CreatedAt:              ExcludeKeyword.CreatedAt,
		}
	}

	return ExcludeKeywords, nil
}
