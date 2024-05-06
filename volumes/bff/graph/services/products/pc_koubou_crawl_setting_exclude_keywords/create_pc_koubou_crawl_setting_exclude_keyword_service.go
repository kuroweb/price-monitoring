package pc_koubou_crawl_setting_exclude_keywords

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

type ICreatePcKoubouCrawlSettingExcludeKeywordService interface {
	CreatePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, input model.CreatePcKoubouCrawlSettingExcludeKeywordInput) (model.CreatePcKoubouCrawlSettingExcludeKeywordResult, error)
}

type CreatePcKoubouCrawlSettingExcludeKeywordService struct{}

func (c *CreatePcKoubouCrawlSettingExcludeKeywordService) CreatePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, input model.CreatePcKoubouCrawlSettingExcludeKeywordInput) (model.CreatePcKoubouCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_keywords", cfg.BackendUrl, input.ProductID)

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

	result := model.CreatePcKoubouCrawlSettingExcludeKeywordResultSuccess{
		Ok: true,
		PcKoubouCrawlSettingExcludeKeyword: &model.PcKoubouCrawlSettingExcludeKeyword{
			ID:      strconv.Itoa(response.ID),
			Keyword: &response.Keyword,
		},
	}

	return result, nil
}

func (c *CreatePcKoubouCrawlSettingExcludeKeywordService) handleServerError() model.CreatePcKoubouCrawlSettingExcludeKeywordResultError {
	return model.CreatePcKoubouCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.CreatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
