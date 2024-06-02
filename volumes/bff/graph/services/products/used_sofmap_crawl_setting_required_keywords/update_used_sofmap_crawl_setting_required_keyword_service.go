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

type IUpdateUsedSofmapCrawlSettingRequiredKeywordService interface {
	UpdateUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateUsedSofmapCrawlSettingRequiredKeywordInput) (model.UpdateUsedSofmapCrawlSettingRequiredKeywordResult, error)
}

type UpdateUsedSofmapCrawlSettingRequiredKeywordService struct{}

func (u *UpdateUsedSofmapCrawlSettingRequiredKeywordService) UpdateUsedSofmapCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdateUsedSofmapCrawlSettingRequiredKeywordInput) (model.UpdateUsedSofmapCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/used_sofmap_crawl_settings/used_sofmap_crawl_setting_required_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		return u.handleApiError(resp), nil
	}

	var response struct {
		ID                       int     `json:"id"`
		UsedSofmapCrawlSettingID int     `json:"used_sofmap_crawl_setting_id"`
		Keyword                  *string `json:"keyword"`
		CreatedAt                string  `json:"created_at"`
		UpdatedAt                string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		UsedSofmapCrawlSettingRequiredKeyword: &model.UsedSofmapCrawlSettingRequiredKeyword{
			ID:                       strconv.Itoa(response.ID),
			UsedSofmapCrawlSettingID: response.UsedSofmapCrawlSettingID,
			Keyword:                  response.Keyword,
			CreatedAt:                response.CreatedAt,
			UpdatedAt:                response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdateUsedSofmapCrawlSettingRequiredKeywordService) handleServerError() model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultError {
	return model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdateUsedSofmapCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.UpdateUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
