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

type IUpdateMercariCrawlSettingRequiredKeywordService interface {
	UpdateMercariCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateMercariCrawlSettingRequiredKeywordInput) (model.UpdateMercariCrawlSettingRequiredKeywordResult, error)
}

type UpdateMercariCrawlSettingRequiredKeywordService struct{}

func (u *UpdateMercariCrawlSettingRequiredKeywordService) UpdateMercariCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateMercariCrawlSettingRequiredKeywordInput) (model.UpdateMercariCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/mercari_crawl_settings/mercari_crawl_setting_required_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

	body := map[string]interface{}{
		"keyword": input.Keyword,
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return u.handleServerError(), nil
	}

	req, err := http.NewRequest(http.MethodPatch, url, bytes.NewBuffer(requestBody))
	if err != nil {
		return u.handleServerError(), nil
	}

	req.Header.Set("Content-Type", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return u.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return u.handleServerError(), nil
	}

	var response struct {
		ID                    int     `json:"id"`
		MercariCrawlSettingID int     `json:"mercari_crawl_setting_id"`
		Keyword               *string `json:"keyword"`
		CreatedAt             string  `json:"created_at"`
		UpdatedAt             string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateMercariCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		MercariCrawlSettingRequiredKeyword: &model.MercariCrawlSettingRequiredKeyword{
			ID:                    strconv.Itoa(response.ID),
			MercariCrawlSettingID: response.MercariCrawlSettingID,
			Keyword:               response.Keyword,
			CreatedAt:             response.CreatedAt,
			UpdatedAt:             response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateMercariCrawlSettingRequiredKeywordService) handleServerError() model.UpdateMercariCrawlSettingRequiredKeywordResultError {
	return model.UpdateMercariCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
