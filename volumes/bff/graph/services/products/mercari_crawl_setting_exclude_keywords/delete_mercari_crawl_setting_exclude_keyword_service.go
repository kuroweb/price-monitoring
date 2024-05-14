package mercari_crawl_setting_exclude_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteMercariCrawlSettingExcludeKeywordService interface {
	DeleteMercariCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeKeywordResult, error)
}

type DeleteMercariCrawlSettingExcludeKeywordService struct{}

func (d *DeleteMercariCrawlSettingExcludeKeywordService) DeleteMercariCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteMercariCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    "503",
				Message: "Service is currently unavailable.",
				Details: []*model.ErrorDetail{},
			},
		}

		return result, nil
	}

	resp, err := client.Do(req)
	if err != nil {
		return d.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return d.handleApiError(resp), nil
	}

	return model.DeleteMercariCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteMercariCrawlSettingExcludeKeywordService) handleServerError() model.DeleteMercariCrawlSettingExcludeKeywordResultError {
	return model.DeleteMercariCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteMercariCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.DeleteMercariCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteMercariCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
