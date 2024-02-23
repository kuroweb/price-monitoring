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

type IUpdateYahooAuctionCrawlSettingExcludeConditionService interface {
	UpdateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.UpdateYahooAuctionCrawlSettingExcludeConditionInput) (model.UpdateYahooAuctionCrawlSettingExcludeConditionResult, error)
}

type UpdateYahooAuctionCrawlSettingExcludeConditionService struct{}

func (u *UpdateYahooAuctionCrawlSettingExcludeConditionService) UpdateYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, input model.UpdateYahooAuctionCrawlSettingExcludeConditionInput) (model.UpdateYahooAuctionCrawlSettingExcludeConditionResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_conditions/%s", cfg.BackendUrl, input.ProductID, input.ID)

	body := map[string]interface{}{
		"keyword":          input.Keyword,
		"yahoo_auction_id": input.YahooAuctionID,
		"seller_id":        input.SellerID,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return u.handleServerError(), nil
	}

	req, err := http.NewRequest(http.MethodPatch, url, bytes.NewBuffer(requestBody))
	if err != nil {
		return u.handleServerError(), nil
	}

	req.Header.Set("Content-Type", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return u.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return u.handleServerError(), nil
	}

	var response struct {
		ID                         int     `json:"id"`
		YahooAuctionCrawlSettingID int     `json:"yahoo_auction_crawl_setting_id"`
		YahooAuctionID             *string `json:"yahoo_auction_id"`
		Keyword                    *string `json:"keyword"`
		SellerID                   *string `json:"seller_id"`
		CreatedAt                  string  `json:"created_at"`
		UpdatedAt                  string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateYahooAuctionCrawlSettingExcludeConditionResultSuccess{
		Ok: true,
		YahooAuctionCrawlSettingExcludeCondition: &model.YahooAuctionCrawlSettingExcludeCondition{
			ID:                         strconv.Itoa(response.ID),
			YahooAuctionCrawlSettingID: response.YahooAuctionCrawlSettingID,
			YahooAuctionID:             response.YahooAuctionID,
			Keyword:                    response.Keyword,
			SellerID:                   response.SellerID,
			CreatedAt:                  response.CreatedAt,
			UpdatedAt:                  response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateYahooAuctionCrawlSettingExcludeConditionService) handleServerError() model.UpdateYahooAuctionCrawlSettingExcludeConditionResultError {
	return model.UpdateYahooAuctionCrawlSettingExcludeConditionResultError{
		Ok: false,
		Error: model.UpdateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
