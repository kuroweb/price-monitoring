package used_sofmap_crawl_setting_exclude_products

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type ICreateUsedSofmapCrawlSettingExcludeProductService interface {
	CreateUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, input model.CreateUsedSofmapCrawlSettingExcludeProductInput) (model.CreateUsedSofmapCrawlSettingExcludeProductResult, error)
}

type CreateUsedSofmapCrawlSettingExcludeProductService struct{}

func (c *CreateUsedSofmapCrawlSettingExcludeProductService) CreateUsedSofmapCrawlSettingExcludeProduct(ctx context.Context, input model.CreateUsedSofmapCrawlSettingExcludeProductInput) (model.CreateUsedSofmapCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_exclude_products", cfg.BackendUrl, input.ProductID)

	body := map[string]interface{}{
		"external_id": input.ExternalID,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return c.handleServerError(), nil
	}

	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return c.handleApiError(resp), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.handleApiError(resp), nil
	}

	var response struct {
		ID         int    `json:"id"`
		ExternalID string `json:"external_id"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateUsedSofmapCrawlSettingExcludeProductResultSuccess{
		Ok: true,
		UsedSofmapCrawlSettingExcludeProduct: &model.UsedSofmapCrawlSettingExcludeProduct{
			ID:         strconv.Itoa(response.ID),
			ExternalID: response.ExternalID,
		},
	}

	return result, nil
}

func (c *CreateUsedSofmapCrawlSettingExcludeProductService) handleServerError() model.CreateUsedSofmapCrawlSettingExcludeProductResultError {
	return model.CreateUsedSofmapCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.CreateUsedSofmapCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (c *CreateUsedSofmapCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.CreateUsedSofmapCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.CreateUsedSofmapCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.CreateUsedSofmapCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return c.handleServerError()
}
