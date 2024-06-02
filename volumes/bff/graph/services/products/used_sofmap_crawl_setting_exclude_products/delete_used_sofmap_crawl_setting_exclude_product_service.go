package used_sofmap_crawl_setting_exclude_products

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteUsedSofmapCrawlSettingExcludeProductService interface {
	DeleteUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteUsedSofmapCrawlSettingExcludeProductResult, error)
}

type DeleteUsedSofmapCrawlSettingExcludeProductService struct{}

func (d *DeleteUsedSofmapCrawlSettingExcludeProductService) DeleteUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, id string, productID string) (model.DeleteUsedSofmapCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_exclude_products/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteUsedSofmapCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailed{
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

	return model.DeleteUsedSofmapCrawlSettingExcludeProductResultSuccess{Ok: true}, nil
}

func (d *DeleteUsedSofmapCrawlSettingExcludeProductService) handleServerError() model.DeleteUsedSofmapCrawlSettingExcludeProductResultError {
	return model.DeleteUsedSofmapCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteUsedSofmapCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.DeleteUsedSofmapCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteUsedSofmapCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.DeleteUsedSofmapCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
