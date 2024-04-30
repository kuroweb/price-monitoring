package janpara_crawl_setting_required_keywords

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

type IUpdateJanparaCrawlSettingRequiredKeywordService interface {
	UpdateJanparaCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateJanparaCrawlSettingRequiredKeywordInput) (model.UpdateJanparaCrawlSettingRequiredKeywordResult, error)
}

type UpdateJanparaCrawlSettingRequiredKeywordService struct{}

func (u *UpdateJanparaCrawlSettingRequiredKeywordService) UpdateJanparaCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateJanparaCrawlSettingRequiredKeywordInput) (model.UpdateJanparaCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_required_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		return u.handleServerError(), nil
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

	result := model.UpdateJanparaCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		JanparaCrawlSettingRequiredKeyword: &model.JanparaCrawlSettingRequiredKeyword{
			ID:                    strconv.Itoa(response.ID),
			JanparaCrawlSettingID: response.JanparaCrawlSettingID,
			Keyword:               response.Keyword,
			CreatedAt:             response.CreatedAt,
			UpdatedAt:             response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateJanparaCrawlSettingRequiredKeywordService) handleServerError() model.UpdateJanparaCrawlSettingRequiredKeywordResultError {
	return model.UpdateJanparaCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.UpdateJanparaCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
