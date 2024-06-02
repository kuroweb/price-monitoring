package used_sofmap_crawl_setting_required_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteUsedSofmapCrawlSettingRequiredKeywordService interface {
	DeleteUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteUsedSofmapCrawlSettingRequiredKeywordResult, error)
}

type DeleteUsedSofmapCrawlSettingRequiredKeywordService struct{}

func (d *DeleteUsedSofmapCrawlSettingRequiredKeywordService) DeleteUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeleteUsedSofmapCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
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

	return model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
}

func (d *DeleteUsedSofmapCrawlSettingRequiredKeywordService) handleServerError() model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultError {
	return model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeleteUsedSofmapCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
