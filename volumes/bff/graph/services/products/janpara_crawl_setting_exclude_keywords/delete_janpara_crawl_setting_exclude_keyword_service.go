package janpara_crawl_setting_exclude_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

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

	if resp.StatusCode != http.StatusOK {
		return d.handleApiError(resp), nil
	}

	return model.DeleteJanparaCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteJanparaCrawlSettingExcludeKeywordService) handleServerError() model.DeleteJanparaCrawlSettingExcludeKeywordResultError {
	return model.DeleteJanparaCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteJanparaCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.DeleteJanparaCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteJanparaCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
