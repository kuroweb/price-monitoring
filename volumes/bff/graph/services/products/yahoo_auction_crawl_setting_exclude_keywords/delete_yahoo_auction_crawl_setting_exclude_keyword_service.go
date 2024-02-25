package yahoo_auction_crawl_setting_exclude_keywords

import (
	"context"
	"fmt"
	"net/http"

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

	switch resp.StatusCode {
	case http.StatusOK:
		return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteYahooAuctionCrawlSettingExcludeKeywordService) handleServerError() model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError {
	return model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
