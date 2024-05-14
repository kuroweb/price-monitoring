package mercari_crawl_setting_required_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteMercariCrawlSettingRequiredKeywordService interface {
	DeleteMercariCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingRequiredKeywordResult, error)
}

type DeleteMercariCrawlSettingRequiredKeywordService struct{}

func (d *DeleteMercariCrawlSettingRequiredKeywordService) DeleteMercariCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteMercariCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteMercariCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
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

	return model.DeleteMercariCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteMercariCrawlSettingRequiredKeywordService) handleServerError() model.DeleteMercariCrawlSettingRequiredKeywordResultError {
	return model.DeleteMercariCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteMercariCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.DeleteMercariCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteMercariCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
