package iosys_crawl_setting_required_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteIosysCrawlSettingRequiredKeywordService interface {
	DeleteIosysCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteIosysCrawlSettingRequiredKeywordResult, error)
}

type DeleteIosysCrawlSettingRequiredKeywordService struct{}

func (d *DeleteIosysCrawlSettingRequiredKeywordService) DeleteIosysCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteIosysCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteIosysCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed{
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
		return model.DeleteIosysCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteIosysCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteIosysCrawlSettingRequiredKeywordService) handleServerError() model.DeleteIosysCrawlSettingRequiredKeywordResultError {
	return model.DeleteIosysCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
