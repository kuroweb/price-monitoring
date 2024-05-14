package yahoo_auction_crawl_setting_exclude_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteYahooAuctionCrawlSettingExcludeKeywordService interface {
	DeleteYahooAuctionCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeKeywordResult, error)
}

type DeleteYahooAuctionCrawlSettingExcludeKeywordService struct{}

func (d *DeleteYahooAuctionCrawlSettingExcludeKeywordService) DeleteYahooAuctionCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "503",
				Message: "Service is currently unavailable.",
				Details: []*model.ErrorDetail{},
			},
		}

		return result, nil
	}

	resp, err := client.Do(req)
	if err != nil {
		return d.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return d.handleApiError(resp), nil
	}

	return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteYahooAuctionCrawlSettingExcludeKeywordService) handleServerError() model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError {
	return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteYahooAuctionCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
