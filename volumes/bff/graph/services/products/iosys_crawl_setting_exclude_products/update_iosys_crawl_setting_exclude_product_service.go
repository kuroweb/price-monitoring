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

type IUpdateIosysCrawlSettingExcludeProductService interface {
	UpdateIosysCrawlSettingExcludeProduct(ctx context.Context, input model.UpdateIosysCrawlSettingExcludeProductInput) (model.UpdateIosysCrawlSettingExcludeProductResult, error)
}

type UpdateIosysCrawlSettingExcludeProductService struct{}

func (u *UpdateIosysCrawlSettingExcludeProductService) UpdateIosysCrawlSettingExcludeProduct(ctx context.Context, input model.UpdateIosysCrawlSettingExcludeProductInput) (model.UpdateIosysCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_products/%s", cfg.BackendUrl, input.ProductID, input.ID)

	body := map[string]interface{}{
		"external_id": input.ExternalID,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return u.handleServerError(), nil
	}

	req, err := http.NewRequest(http.MethodPatch, url, bytes.NewBuffer(requestBody))
	if err != nil {
		return u.handleServerError(), nil
	}

	req.Header.Set("Content-Type", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return u.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return u.handleApiError(resp), nil
	}

	var response struct {
		ID                  int    `json:"id"`
		IosysCrawlSettingID int    `json:"iosys_crawl_setting_id"`
		ExternalID          string `json:"external_id"`
		CreatedAt           string `json:"created_at"`
		UpdatedAt           string `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateIosysCrawlSettingExcludeProductResultSuccess{
		Ok: true,
		IosysCrawlSettingExcludeProduct: &model.IosysCrawlSettingExcludeProduct{
			ID:                  strconv.Itoa(response.ID),
			IosysCrawlSettingID: response.IosysCrawlSettingID,
			ExternalID:          response.ExternalID,
			CreatedAt:           response.CreatedAt,
			UpdatedAt:           response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateIosysCrawlSettingExcludeProductService) handleServerError() model.UpdateIosysCrawlSettingExcludeProductResultError {
	return model.UpdateIosysCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.UpdateIosysCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdateIosysCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.UpdateIosysCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdateIosysCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.UpdateIosysCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
