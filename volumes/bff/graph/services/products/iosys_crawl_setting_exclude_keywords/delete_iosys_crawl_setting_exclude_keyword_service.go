package iosys_crawl_setting_exclude_keywords

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteIosysCrawlSettingExcludeKeywordService interface {
	DeleteIosysCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteIosysCrawlSettingExcludeKeywordResult, error)
}

type DeleteIosysCrawlSettingExcludeKeywordService struct{}

func (d *DeleteIosysCrawlSettingExcludeKeywordService) DeleteIosysCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteIosysCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteIosysCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed{
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
		return model.DeleteIosysCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteIosysCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteIosysCrawlSettingExcludeKeywordService) handleServerError() model.DeleteIosysCrawlSettingExcludeKeywordResultError {
	return model.DeleteIosysCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
