package janpara_crawl_setting_exclude_products

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

type IUpdateJanparaCrawlSettingExcludeProductService interface {
	UpdateJanparaCrawlSettingExcludeProduct(ctx context.Context, input model.UpdateJanparaCrawlSettingExcludeProductInput) (model.UpdateJanparaCrawlSettingExcludeProductResult, error)
}

type UpdateJanparaCrawlSettingExcludeProductService struct{}

func (u *UpdateJanparaCrawlSettingExcludeProductService) UpdateJanparaCrawlSettingExcludeProduct(ctx context.Context, input model.UpdateJanparaCrawlSettingExcludeProductInput) (model.UpdateJanparaCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_products/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		ID                    int    `json:"id"`
		JanparaCrawlSettingID int    `json:"janpara_crawl_setting_id"`
		ExternalID            string `json:"external_id"`
		CreatedAt             string `json:"created_at"`
		UpdatedAt             string `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateJanparaCrawlSettingExcludeProductResultSuccess{
		Ok: true,
		JanparaCrawlSettingExcludeProduct: &model.JanparaCrawlSettingExcludeProduct{
			ID:                    strconv.Itoa(response.ID),
			JanparaCrawlSettingID: response.JanparaCrawlSettingID,
			ExternalID:            response.ExternalID,
			CreatedAt:             response.CreatedAt,
			UpdatedAt:             response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateJanparaCrawlSettingExcludeProductService) handleServerError() model.UpdateJanparaCrawlSettingExcludeProductResultError {
	return model.UpdateJanparaCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.UpdateJanparaCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdateJanparaCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.UpdateJanparaCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdateJanparaCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.UpdateJanparaCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
