package mercari_crawl_setting_exclude_products

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteMercariCrawlSettingExcludeProductService interface {
	DeleteMercariCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeProductResult, error)
}

type DeleteMercariCrawlSettingExcludeProductService struct{}

func (d *DeleteMercariCrawlSettingExcludeProductService) DeleteMercariCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_exclude_products/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteMercariCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeProductResultValidationFailed{
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

	return model.DeleteMercariCrawlSettingExcludeProductResultSuccess{Ok: true}, nil
}

func (d *DeleteMercariCrawlSettingExcludeProductService) handleServerError() model.DeleteMercariCrawlSettingExcludeProductResultError {
	return model.DeleteMercariCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.DeleteMercariCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteMercariCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.DeleteMercariCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteMercariCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
