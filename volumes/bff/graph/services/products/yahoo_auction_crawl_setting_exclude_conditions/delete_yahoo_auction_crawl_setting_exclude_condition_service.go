package yahoo_auction_crawl_setting_exclude_conditions

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteYahooAuctionCrawlSettingExcludeConditionService interface {
	DeleteYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeConditionResult, error)
}

type DeleteYahooAuctionCrawlSettingExcludeConditionService struct{}

func (d *DeleteYahooAuctionCrawlSettingExcludeConditionService) DeleteYahooAuctionCrawlSettingExcludeCondition(ctx context.Context, id string, productID string) (model.DeleteYahooAuctionCrawlSettingExcludeConditionResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_conditions/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteYahooAuctionCrawlSettingExcludeConditionResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed{
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

	switch resp.StatusCode {
	case http.StatusOK:
		return model.DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteYahooAuctionCrawlSettingExcludeConditionResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteYahooAuctionCrawlSettingExcludeConditionService) handleServerError() model.DeleteYahooAuctionCrawlSettingExcludeConditionResultError {
	return model.DeleteYahooAuctionCrawlSettingExcludeConditionResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
