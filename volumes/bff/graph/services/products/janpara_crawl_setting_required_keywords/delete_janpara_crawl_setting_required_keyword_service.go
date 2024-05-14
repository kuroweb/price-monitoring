package janpara_crawl_setting_required_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

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

	if resp.StatusCode != http.StatusOK {
		return d.handleApiError(resp), nil
	}

	return model.DeleteJanparaCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteJanparaCrawlSettingRequiredKeywordService) handleServerError() model.DeleteJanparaCrawlSettingRequiredKeywordResultError {
	return model.DeleteJanparaCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteJanparaCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.DeleteJanparaCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteJanparaCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
