package iosys_crawl_setting_required_keywords

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

type ICreateIosysCrawlSettingRequiredKeywordService interface {
	CreateIosysCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateIosysCrawlSettingRequiredKeywordInput) (model.CreateIosysCrawlSettingRequiredKeywordResult, error)
}

type CreateIosysCrawlSettingRequiredKeywordService struct{}

func (c *CreateIosysCrawlSettingRequiredKeywordService) CreateIosysCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateIosysCrawlSettingRequiredKeywordInput) (model.CreateIosysCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/iosys_crawl_settings/iosys_crawl_setting_required_keywords", cfg.BackendUrl, input.ProductID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return c.handleServerError(), nil
	}

	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return c.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.handleServerError(), nil
	}

	var response struct {
		ID      int    `json:"id"`
		Keyword string `json:"keyword"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateIosysCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		IosysCrawlSettingRequiredKeyword: &model.IosysCrawlSettingRequiredKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreateIosysCrawlSettingRequiredKeywordService) handleServerError() model.CreateIosysCrawlSettingRequiredKeywordResultError {
	return model.CreateIosysCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.CreateIosysCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
