package janpara_crawl_setting_required_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteJanparaCrawlSettingRequiredKeywordService interface {
	DeleteJanparaCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingRequiredKeywordResult, error)
}

type DeleteJanparaCrawlSettingRequiredKeywordService struct{}

func (d *DeleteJanparaCrawlSettingRequiredKeywordService) DeleteJanparaCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteJanparaCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed{
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
		return model.DeleteJanparaCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteJanparaCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteJanparaCrawlSettingRequiredKeywordService) handleServerError() model.DeleteJanparaCrawlSettingRequiredKeywordResultError {
	return model.DeleteJanparaCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
