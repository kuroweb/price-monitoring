package pc_koubou_crawl_setting_required_keywords

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

type IUpdatePcKoubouCrawlSettingRequiredKeywordService interface {
	UpdatePcKoubouCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdatePcKoubouCrawlSettingRequiredKeywordInput) (model.UpdatePcKoubouCrawlSettingRequiredKeywordResult, error)
}

type UpdatePcKoubouCrawlSettingRequiredKeywordService struct{}

func (u *UpdatePcKoubouCrawlSettingRequiredKeywordService) UpdatePcKoubouCrawlSettingRequiredKeyword(ctx context.Context, input model.UpdatePcKoubouCrawlSettingRequiredKeywordInput) (model.UpdatePcKoubouCrawlSettingRequiredKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_required_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

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
		ID                     int     `json:"id"`
		PcKoubouCrawlSettingID int     `json:"pc_koubou_crawl_setting_id"`
		Keyword                *string `json:"keyword"`
		CreatedAt              string  `json:"created_at"`
		UpdatedAt              string  `json:"updated_at"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccess{
		Ok: true,
		PcKoubouCrawlSettingRequiredKeyword: &model.PcKoubouCrawlSettingRequiredKeyword{
			ID:                     strconv.Itoa(response.ID),
			PcKoubouCrawlSettingID: response.PcKoubouCrawlSettingID,
			Keyword:                response.Keyword,
			CreatedAt:              response.CreatedAt,
			UpdatedAt:              response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdatePcKoubouCrawlSettingRequiredKeywordService) handleServerError() model.UpdatePcKoubouCrawlSettingRequiredKeywordResultError {
	return model.UpdatePcKoubouCrawlSettingRequiredKeywordResultError{
		Ok: false,
		Error: model.UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
			Code:    "503",
			Message: "Internal Server Error.",
			Details: []*model.ErrorDetail{},
		},
	}
}

func (u *UpdatePcKoubouCrawlSettingRequiredKeywordService) handleApiError(resp *http.Response) model.UpdatePcKoubouCrawlSettingRequiredKeywordResultError {
	var errorResponse struct {
		Error  string `json:"error"`
		Status int    `json:"status"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&errorResponse); err == nil {
		return model.UpdatePcKoubouCrawlSettingRequiredKeywordResultError{
			Ok: false,
			Error: model.UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailed{
				Code:    strconv.Itoa(errorResponse.Status),
				Message: errorResponse.Error,
				Details: []*model.ErrorDetail{},
			},
		}
	}

	return u.handleServerError()
}
