package janpara_crawl_setting_exclude_keywords

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

type IUpdateJanparaCrawlSettingExcludeKeywordService interface {
	UpdateJanparaCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdateJanparaCrawlSettingExcludeKeywordInput) (model.UpdateJanparaCrawlSettingExcludeKeywordResult, error)
}

type UpdateJanparaCrawlSettingExcludeKeywordService struct{}

func (u *UpdateJanparaCrawlSettingExcludeKeywordService) UpdateJanparaCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdateJanparaCrawlSettingExcludeKeywordInput) (model.UpdateJanparaCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
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
		ID                    int     `json:"id"`
		JanparaCrawlSettingID int     `json:"janpara_crawl_setting_id"`
		Keyword               *string `json:"keyword"`
		CreatedAt             string  `json:"created_at"`
		UpdatedAt             string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateJanparaCrawlSettingExcludeKeywordResultSuccess{
		Ok: true,
		JanparaCrawlSettingExcludeKeyword: &model.JanparaCrawlSettingExcludeKeyword{
			ID:                    strconv.Itoa(response.ID),
			JanparaCrawlSettingID: response.JanparaCrawlSettingID,
			Keyword:               response.Keyword,
			CreatedAt:             response.CreatedAt,
			UpdatedAt:             response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateJanparaCrawlSettingExcludeKeywordService) handleServerError() model.UpdateJanparaCrawlSettingExcludeKeywordResultError {
	return model.UpdateJanparaCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.UpdateJanparaCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdateJanparaCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.UpdateJanparaCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdateJanparaCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.UpdateJanparaCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
