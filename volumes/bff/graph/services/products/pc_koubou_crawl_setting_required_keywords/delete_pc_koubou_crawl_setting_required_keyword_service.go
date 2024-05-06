package pc_koubou_crawl_setting_required_keywords

import (
	"context"
	"fmt"
	"net/http"

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

	switch resp.StatusCode {
	case http.StatusOK:
		return model.DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeletePcKoubouCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeletePcKoubouCrawlSettingRequiredKeywordService) handleServerError() model.DeletePcKoubouCrawlSettingRequiredKeywordResultError {
	return model.DeletePcKoubouCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
