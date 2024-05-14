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

type ICreateYahooAuctionCrawlSettingRequiredKeywordService interface {
	CreateYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateYahooAuctionCrawlSettingRequiredKeywordInput) (model.CreateYahooAuctionCrawlSettingRequiredKeywordResult, error)
}

type CreateYahooAuctionCrawlSettingRequiredKeywordService struct{}

func (c *CreateYahooAuctionCrawlSettingRequiredKeywordService) CreateYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateYahooAuctionCrawlSettingRequiredKeywordInput) (model.CreateYahooAuctionCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_required_keywords", cfg.BackendUrl, input.ProductID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return c.handleServerError(), nil
	}

	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return c.handleApiError(resp), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.handleApiError(resp), nil
	}

	var response struct {
		ID      int    `json:"id"`
		Keyword string `json:"keyword"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		YahooAuctionCrawlSettingRequiredKeyword: &model.YahooAuctionCrawlSettingRequiredKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreateYahooAuctionCrawlSettingRequiredKeywordService) handleServerError() model.CreateYahooAuctionCrawlSettingRequiredKeywordResultError {
	return model.CreateYahooAuctionCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (c *CreateYahooAuctionCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.CreateYahooAuctionCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.CreateYahooAuctionCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return c.handleServerError()
}
