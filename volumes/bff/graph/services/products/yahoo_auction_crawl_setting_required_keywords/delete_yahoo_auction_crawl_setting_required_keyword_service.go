package yahoo_auction_crawl_setting_required_keywords

import (
	"context"
	"fmt"
	"net/http"

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

	switch resp.StatusCode {
	case http.StatusOK:
		return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteYahooAuctionCrawlSettingRequiredKeywordService) handleServerError() model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError {
	return model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
