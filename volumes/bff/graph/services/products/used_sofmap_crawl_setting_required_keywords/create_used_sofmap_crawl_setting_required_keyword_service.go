package used_sofmap_crawl_setting_required_keywords

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

type ICreateUsedSofmapCrawlSettingRequiredKeywordService interface {
	CreateUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateUsedSofmapCrawlSettingRequiredKeywordInput) (model.CreateUsedSofmapCrawlSettingRequiredKeywordResult, error)
}

type CreateUsedSofmapCrawlSettingRequiredKeywordService struct{}

func (c *CreateUsedSofmapCrawlSettingRequiredKeywordService) CreateUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateUsedSofmapCrawlSettingRequiredKeywordInput) (model.CreateUsedSofmapCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_required_keywords", cfg.BackendUrl, input.ProductID)

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

	result := model.CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		UsedSofmapCrawlSettingRequiredKeyword: &model.UsedSofmapCrawlSettingRequiredKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreateUsedSofmapCrawlSettingRequiredKeywordService) handleServerError() model.CreateUsedSofmapCrawlSettingRequiredKeywordResultError {
	return model.CreateUsedSofmapCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.CreateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (c *CreateUsedSofmapCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.CreateUsedSofmapCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.CreateUsedSofmapCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.CreateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return c.handleServerError()
}
