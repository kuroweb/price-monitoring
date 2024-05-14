package pc_koubou_crawl_setting_exclude_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeletePcKoubouCrawlSettingExcludeKeywordService interface {
	DeletePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeletePcKoubouCrawlSettingExcludeKeywordResult, error)
}

type DeletePcKoubouCrawlSettingExcludeKeywordService struct{}

func (d *DeletePcKoubouCrawlSettingExcludeKeywordService) DeletePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, id string, productID string) (model.DeletePcKoubouCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeletePcKoubouCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed{
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

	return model.DeletePcKoubouCrawlSettingExcludeKeywordResultSuccess{Ok: true}, nil
}

func (d *DeletePcKoubouCrawlSettingExcludeKeywordService) handleServerError() model.DeletePcKoubouCrawlSettingExcludeKeywordResultError {
	return model.DeletePcKoubouCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeletePcKoubouCrawlSettingExcludeKeywordService) handleApiError(resp *http.Response) model.DeletePcKoubouCrawlSettingExcludeKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeletePcKoubouCrawlSettingExcludeKeywordResultError{
			Ok: false,
			Error: model.DeletePcKoubouCrawlSettingExcludeKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
