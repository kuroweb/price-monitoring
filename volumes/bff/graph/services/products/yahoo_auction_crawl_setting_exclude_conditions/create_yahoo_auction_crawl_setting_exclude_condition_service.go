package yahoo_auction_crawl_setting_exclude_conditions

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type ICreateYahooAuctionCrawlSettingExcludeConditionService interface {
	CreateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.CreateYahooAuctionCrawlSettingExcludeConditionInput) (model.CreateYahooAuctionCrawlSettingExcludeConditionResult, error)
}

type CreateYahooAuctionCrawlSettingExcludeConditionService struct{}

func (c *CreateYahooAuctionCrawlSettingExcludeConditionService) CreateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.CreateYahooAuctionCrawlSettingExcludeConditionInput) (model.CreateYahooAuctionCrawlSettingExcludeConditionResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_conditions", cfg.BackendUrl, input.ProductID)

	body := map[string]interface{}{
		"keyword":          input.Keyword,
		"yahoo_auction_id": input.YahooAuctionID,
		"seller_id":        input.SellerID,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return c.handleServerError(), nil
	}

	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return c.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.handleServerError(), nil
	}

	var response struct {
		ID             int    `json:"id"`
		Keyword        string `json:"keyword"`
		YahooAuctionID string `json:"yahoo_auction_id"`
		SellerID       string `json:"seller_id"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess{
		Ok: true,
		Product: &model.YahooAuctionCrawlSettingExcludeCondition{
			ID:             strconv.Itoa(response.ID),
			Keyword:        &response.Keyword,
			YahooAuctionID: &response.YahooAuctionID,
			SellerID:       &response.SellerID,
		},
	}

	return result, nil
}

func (c *CreateYahooAuctionCrawlSettingExcludeConditionService) handleServerError() model.CreateYahooAuctionCrawlSettingExcludeConditionResultError {
	return model.CreateYahooAuctionCrawlSettingExcludeConditionResultError{
		Ok: false,
		Error: model.CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
