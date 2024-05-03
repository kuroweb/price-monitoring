package iosys_crawl_setting_exclude_keywords

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

type IUpdateIosysCrawlSettingExcludeKeywordService interface {
	UpdateIosysCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdateIosysCrawlSettingExcludeKeywordInput) (model.UpdateIosysCrawlSettingExcludeKeywordResult, error)
}

type UpdateIosysCrawlSettingExcludeKeywordService struct{}

func (u *UpdateIosysCrawlSettingExcludeKeywordService) UpdateIosysCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdateIosysCrawlSettingExcludeKeywordInput) (model.UpdateIosysCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		ID                  int     `json:"id"`
		IosysCrawlSettingID int     `json:"iosys_crawl_setting_id"`
		Keyword             *string `json:"keyword"`
		CreatedAt           string  `json:"created_at"`
		UpdatedAt           string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateIosysCrawlSettingExcludeKeywordResultSuccess{
		Ok: true,
		IosysCrawlSettingExcludeKeyword: &model.IosysCrawlSettingExcludeKeyword{
			ID:                  strconv.Itoa(response.ID),
			IosysCrawlSettingID: response.IosysCrawlSettingID,
			Keyword:             response.Keyword,
			CreatedAt:           response.CreatedAt,
			UpdatedAt:           response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateIosysCrawlSettingExcludeKeywordService) handleServerError() model.UpdateIosysCrawlSettingExcludeKeywordResultError {
	return model.UpdateIosysCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.UpdateIosysCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
