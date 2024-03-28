package yahoo_auction_crawl_setting_required_keywords

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

type IFindYahooAuctionCrawlSettingRequiredKeywordService interface {
	FindYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingRequiredKeyword, error)
}

type FindYahooAuctionCrawlSettingRequiredKeywordService struct{}

func (f *FindYahooAuctionCrawlSettingRequiredKeywordService) FindYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingRequiredKeyword, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_required_keywords", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch yahoo_auction_crawl_setting_required_keyword data")
	}

	var response struct {
		RequiredKeywords []struct {
			ID                         int     `json:"id"`
			YahooAuctionCrawlSettingID int     `json:"yahoo_auction_crawl_setting_id"`
			Keyword                    *string `json:"keyword"`
			UpdatedAt                  string  `json:"updated_at"`
			CreatedAt                  string  `json:"created_at"`
		} `json:"yahoo_auction_crawl_setting_required_keywords"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	RequiredKeywords := make([]*model.YahooAuctionCrawlSettingRequiredKeyword, len(response.RequiredKeywords))
	for i, RequiredKeyword := range response.RequiredKeywords {
		RequiredKeywords[i] = &model.YahooAuctionCrawlSettingRequiredKeyword{
			ID:                         strconv.Itoa(RequiredKeyword.ID),
			YahooAuctionCrawlSettingID: RequiredKeyword.YahooAuctionCrawlSettingID,
			Keyword:                    RequiredKeyword.Keyword,
			UpdatedAt:                  RequiredKeyword.UpdatedAt,
			CreatedAt:                  RequiredKeyword.CreatedAt,
		}
	}

	return RequiredKeywords, nil
}
