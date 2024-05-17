package janpara_crawl_setting_exclude_products

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteJanparaCrawlSettingExcludeProductService interface {
	DeleteJanparaCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingExcludeProductResult, error)
}

type DeleteJanparaCrawlSettingExcludeProductService struct{}

func (d *DeleteJanparaCrawlSettingExcludeProductService) DeleteJanparaCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteJanparaCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_products/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteJanparaCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingExcludeProductResultValidationFailed{
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

	return model.DeleteJanparaCrawlSettingExcludeProductResultSuccess{Ok: true}, nil
}

func (d *DeleteJanparaCrawlSettingExcludeProductService) handleServerError() model.DeleteJanparaCrawlSettingExcludeProductResultError {
	return model.DeleteJanparaCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.DeleteJanparaCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteJanparaCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.DeleteJanparaCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteJanparaCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteJanparaCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
