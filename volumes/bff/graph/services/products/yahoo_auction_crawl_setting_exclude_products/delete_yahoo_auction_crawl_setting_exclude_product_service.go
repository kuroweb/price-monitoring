package yahoo_auction_crawl_setting_exclude_products

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteYahooAuctionCrawlSettingExcludeProductService interface {
	DeleteYahooAuctionCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeProductResult, error)
}

type DeleteYahooAuctionCrawlSettingExcludeProductService struct{}

func (d *DeleteYahooAuctionCrawlSettingExcludeProductService) DeleteYahooAuctionCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_products/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteYahooAuctionCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed{
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

	return model.DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess{Ok: true}, nil
}

func (d *DeleteYahooAuctionCrawlSettingExcludeProductService) handleServerError() model.DeleteYahooAuctionCrawlSettingExcludeProductResultError {
	return model.DeleteYahooAuctionCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteYahooAuctionCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.DeleteYahooAuctionCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteYahooAuctionCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
