package iosys_crawl_setting_exclude_products

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

type ICreateIosysCrawlSettingExcludeProductService interface {
	CreateIosysCrawlSettingExcludeProduct(ctx context.Context, input model.CreateIosysCrawlSettingExcludeProductInput) (model.CreateIosysCrawlSettingExcludeProductResult, error)
}

type CreateIosysCrawlSettingExcludeProductService struct{}

func (c *CreateIosysCrawlSettingExcludeProductService) CreateIosysCrawlSettingExcludeProduct(ctx context.Context, input model.CreateIosysCrawlSettingExcludeProductInput) (model.CreateIosysCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_products", cfg.BackendUrl, input.ProductID)

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

	result := model.CreateIosysCrawlSettingExcludeProductResultSuccess{
		Ok: true,
		IosysCrawlSettingExcludeProduct: &model.IosysCrawlSettingExcludeProduct{
			ID:         strconv.Itoa(response.ID),
			ExternalID: response.ExternalID,
		},
	}

	return result, nil
}

func (c *CreateIosysCrawlSettingExcludeProductService) handleServerError() model.CreateIosysCrawlSettingExcludeProductResultError {
	return model.CreateIosysCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.CreateIosysCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (c *CreateIosysCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.CreateIosysCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.CreateIosysCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.CreateIosysCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return c.handleServerError()
}
