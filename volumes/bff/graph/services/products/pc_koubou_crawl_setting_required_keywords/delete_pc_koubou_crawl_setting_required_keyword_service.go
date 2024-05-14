package pc_koubou_crawl_setting_required_keywords

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeletePcKoubouCrawlSettingRequiredKeywordService interface {
	DeletePcKoubouCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeletePcKoubouCrawlSettingRequiredKeywordResult, error)
}

type DeletePcKoubouCrawlSettingRequiredKeywordService struct{}

func (d *DeletePcKoubouCrawlSettingRequiredKeywordService) DeletePcKoubouCrawlSettingRequiredKeyword(ctx context.Context, id string, productID string) (model.DeletePcKoubouCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_required_keywords/%s", cfg.BackendUrl, productID, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeletePcKoubouCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
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

	return model.DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
}

func (d *DeletePcKoubouCrawlSettingRequiredKeywordService) handleServerError() model.DeletePcKoubouCrawlSettingRequiredKeywordResultError {
	return model.DeletePcKoubouCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (d *DeletePcKoubouCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.DeletePcKoubouCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.DeletePcKoubouCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return d.handleServerError()
}
