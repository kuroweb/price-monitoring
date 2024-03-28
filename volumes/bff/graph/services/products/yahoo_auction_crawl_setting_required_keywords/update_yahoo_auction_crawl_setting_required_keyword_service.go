package yahoo_auction_crawl_setting_required_keywords

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

type IUpdateYahooAuctionCrawlSettingRequiredKeywordService interface {
	UpdateYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateYahooAuctionCrawlSettingRequiredKeywordInput) (model.UpdateYahooAuctionCrawlSettingRequiredKeywordResult, error)
}

type UpdateYahooAuctionCrawlSettingRequiredKeywordService struct{}

func (u *UpdateYahooAuctionCrawlSettingRequiredKeywordService) UpdateYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateYahooAuctionCrawlSettingRequiredKeywordInput) (model.UpdateYahooAuctionCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_required_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
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
		Keyword                    *string `json:"keyword"`
		CreatedAt                  string  `json:"created_at"`
		UpdatedAt                  string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		YahooAuctionCrawlSettingRequiredKeyword: &model.YahooAuctionCrawlSettingRequiredKeyword{
			ID:                         strconv.Itoa(response.ID),
			YahooAuctionCrawlSettingID: response.YahooAuctionCrawlSettingID,
			Keyword:                    response.Keyword,
			CreatedAt:                  response.CreatedAt,
			UpdatedAt:                  response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateYahooAuctionCrawlSettingRequiredKeywordService) handleServerError() model.UpdateYahooAuctionCrawlSettingRequiredKeywordResultError {
	return model.UpdateYahooAuctionCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
