package mercari_crawl_setting_required_keywords

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

type ICreateMercariCrawlSettingRequiredKeywordService interface {
	CreateMercariCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateMercariCrawlSettingRequiredKeywordInput) (model.CreateMercariCrawlSettingRequiredKeywordResult, error)
}

type CreateMercariCrawlSettingRequiredKeywordService struct{}

func (c *CreateMercariCrawlSettingRequiredKeywordService) CreateMercariCrawlSettingRequiredKeyword(ctx context.Context, input model.CreateMercariCrawlSettingRequiredKeywordInput) (model.CreateMercariCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_required_keywords", cfg.BackendUrl, input.ProductID)

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

	result := model.CreateMercariCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		MercariCrawlSettingRequiredKeyword: &model.MercariCrawlSettingRequiredKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreateMercariCrawlSettingRequiredKeywordService) handleServerError() model.CreateMercariCrawlSettingRequiredKeywordResultError {
	return model.CreateMercariCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.CreateMercariCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
