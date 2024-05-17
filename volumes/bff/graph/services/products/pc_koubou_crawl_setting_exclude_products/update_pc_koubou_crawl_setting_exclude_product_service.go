package pc_koubou_crawl_setting_exclude_products

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

type IUpdatePcKoubouCrawlSettingExcludeProductService interface {
	UpdatePcKoubouCrawlSettingExcludeProduct(ctx context.Context, input model.UpdatePcKoubouCrawlSettingExcludeProductInput) (model.UpdatePcKoubouCrawlSettingExcludeProductResult, error)
}

type UpdatePcKoubouCrawlSettingExcludeProductService struct{}

func (u *UpdatePcKoubouCrawlSettingExcludeProductService) UpdatePcKoubouCrawlSettingExcludeProduct(ctx context.Context, input model.UpdatePcKoubouCrawlSettingExcludeProductInput) (model.UpdatePcKoubouCrawlSettingExcludeProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_products/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		ID                     int    `json:"id"`
		PcKoubouCrawlSettingID int    `json:"pc_koubou_crawl_setting_id"`
		ExternalID             string `json:"external_id"`
		CreatedAt              string `json:"created_at"`
		UpdatedAt              string `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdatePcKoubouCrawlSettingExcludeProductResultSuccess{
		Ok: true,
		PcKoubouCrawlSettingExcludeProduct: &model.PcKoubouCrawlSettingExcludeProduct{
			ID:                     strconv.Itoa(response.ID),
			PcKoubouCrawlSettingID: response.PcKoubouCrawlSettingID,
			ExternalID:             response.ExternalID,
			CreatedAt:              response.CreatedAt,
			UpdatedAt:              response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdatePcKoubouCrawlSettingExcludeProductService) handleServerError() model.UpdatePcKoubouCrawlSettingExcludeProductResultError {
	return model.UpdatePcKoubouCrawlSettingExcludeProductResultError{
		Ok: false,
		Error: model.UpdatePcKoubouCrawlSettingExcludeProductResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdatePcKoubouCrawlSettingExcludeProductService) handleApiError(resp *http.Response) model.UpdatePcKoubouCrawlSettingExcludeProductResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdatePcKoubouCrawlSettingExcludeProductResultError{
			Ok: false,
			Error: model.UpdatePcKoubouCrawlSettingExcludeProductResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
