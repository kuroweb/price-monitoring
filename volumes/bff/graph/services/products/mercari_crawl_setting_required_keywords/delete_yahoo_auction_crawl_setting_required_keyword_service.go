package mercari_crawl_setting_required_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteMercariCrawlSettingRequiredKeywordService interface {
	DeleteMercariCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingRequiredKeywordResult, error)
}

type DeleteMercariCrawlSettingRequiredKeywordService struct{}

func (d *DeleteMercariCrawlSettingRequiredKeywordService) DeleteMercariCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteMercariCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
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
		return model.DeleteMercariCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteMercariCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteMercariCrawlSettingRequiredKeywordService) handleServerError() model.DeleteMercariCrawlSettingRequiredKeywordResultError {
	return model.DeleteMercariCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
