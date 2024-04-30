package janpara_crawl_setting_exclude_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteJanparaCrawlSettingExcludeKeywordService interface {
	DeleteJanparaCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingExcludeKeywordResult, error)
}

type DeleteJanparaCrawlSettingExcludeKeywordService struct{}

func (d *DeleteJanparaCrawlSettingExcludeKeywordService) DeleteJanparaCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteJanparaCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed{
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
		return model.DeleteJanparaCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteJanparaCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteJanparaCrawlSettingExcludeKeywordService) handleServerError() model.DeleteJanparaCrawlSettingExcludeKeywordResultError {
	return model.DeleteJanparaCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
