package yahoo_auction_crawl_setting_exclude_conditions

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

type IFindYahooAuctionCrawlSettingExcludeConditionService interface {
	FindYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingExcludeCondition, error)
}

type FindYahooAuctionCrawlSettingExcludeConditionService struct{}

func (f *FindYahooAuctionCrawlSettingExcludeConditionService) FindYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingExcludeCondition, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/%s/yahoo_auction_crawl_setting_exclude_conditions", cfg.BackendUrl, strconv.Itoa(productID), yahooAuctionCrawlSettingID)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch yahoo_auction_crawl_setting_exclude_condition data")
	}

	var response struct {
		ExcludeConditions []struct {
			ID                         int     `json:"id"`
			YahooAuctionCrawlSettingID int     `json:"yahoo_auction_crawl_setting_id"`
			YahooAuctionID             *string `json:"yahoo_auction_id"`
			Keyword                    *string `json:"keyword"`
			SellerID                   *string `json:"seller_id"`
			UpdatedAt                  string  `json:"updated_at"`
			CreatedAt                  string  `json:"created_at"`
		} `json:"yahoo_auction_crawl_setting_exclude_conditions"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	excludeConditions := make([]*model.YahooAuctionCrawlSettingExcludeCondition, len(response.ExcludeConditions))
	for i, excludeCondition := range response.ExcludeConditions {
		excludeConditions[i] = &model.YahooAuctionCrawlSettingExcludeCondition{
			ID:                         strconv.Itoa(excludeCondition.ID),
			YahooAuctionCrawlSettingID: excludeCondition.YahooAuctionCrawlSettingID,
			YahooAuctionID:             excludeCondition.YahooAuctionID,
			Keyword:                    excludeCondition.Keyword,
			SellerID:                   excludeCondition.SellerID,
			UpdatedAt:                  excludeCondition.UpdatedAt,
			CreatedAt:                  excludeCondition.CreatedAt,
		}
	}

	return excludeConditions, nil
}
