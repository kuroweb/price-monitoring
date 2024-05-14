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

type ICreateJanparaCrawlSettingExcludeKeywordService interface {
	CreateJanparaCrawlSettingExcludeKeyword(ctx context.Context, input model.CreateJanparaCrawlSettingExcludeKeywordInput) (model.CreateJanparaCrawlSettingExcludeKeywordResult, error)
}

type CreateJanparaCrawlSettingExcludeKeywordService struct{}

func (c *CreateJanparaCrawlSettingExcludeKeywordService) CreateJanparaCrawlSettingExcludeKeyword(ctx context.Context, input model.CreateJanparaCrawlSettingExcludeKeywordInput) (model.CreateJanparaCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/janpara_crawl_settings/janpara_crawl_setting_exclude_keywords", cfg.BackendUrl, input.ProductID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
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
		ID      int    `json:"id"`
		Keyword string `json:"keyword"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateJanparaCrawlSettingExcludeKeywordResultSuccess{
		Ok: true,
		JanparaCrawlSettingExcludeKeyword: &model.JanparaCrawlSettingExcludeKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreateJanparaCrawlSettingExcludeKeywordService) handleServerError() model.CreateJanparaCrawlSettingExcludeKeywordResultError {
	return model.CreateJanparaCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.CreateJanparaCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (c *CreateJanparaCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.CreateJanparaCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.CreateJanparaCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.CreateJanparaCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return c.handleServerError()
}
