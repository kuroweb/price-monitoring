package mercari_crawl_setting_exclude_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteMercariCrawlSettingExcludeKeywordService interface {
	DeleteMercariCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeKeywordResult, error)
}

type DeleteMercariCrawlSettingExcludeKeywordService struct{}

func (d *DeleteMercariCrawlSettingExcludeKeywordService) DeleteMercariCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteMercariCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
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
		return model.DeleteMercariCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteMercariCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteMercariCrawlSettingExcludeKeywordService) handleServerError() model.DeleteMercariCrawlSettingExcludeKeywordResultError {
	return model.DeleteMercariCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
