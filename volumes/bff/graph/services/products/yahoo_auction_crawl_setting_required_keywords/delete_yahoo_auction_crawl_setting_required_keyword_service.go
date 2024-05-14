package yahoo_auction_crawl_setting_required_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteYahooAuctionCrawlSettingRequiredKeywordService interface {
	DeleteYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingRequiredKeywordResult, error)
}

type DeleteYahooAuctionCrawlSettingRequiredKeywordService struct{}

func (d *DeleteYahooAuctionCrawlSettingRequiredKeywordService) DeleteYahooAuctionCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
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

	return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteYahooAuctionCrawlSettingRequiredKeywordService) handleServerError() model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError {
	return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteYahooAuctionCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
