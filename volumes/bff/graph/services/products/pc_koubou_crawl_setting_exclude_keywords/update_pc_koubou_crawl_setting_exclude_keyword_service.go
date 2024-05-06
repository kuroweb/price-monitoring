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

type IUpdatePcKoubouCrawlSettingExcludeKeywordService interface {
	UpdatePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdatePcKoubouCrawlSettingExcludeKeywordInput) (model.UpdatePcKoubouCrawlSettingExcludeKeywordResult, error)
}

type UpdatePcKoubouCrawlSettingExcludeKeywordService struct{}

func (u *UpdatePcKoubouCrawlSettingExcludeKeywordService) UpdatePcKoubouCrawlSettingExcludeKeyword(ctx context.Context, input model.UpdatePcKoubouCrawlSettingExcludeKeywordInput) (model.UpdatePcKoubouCrawlSettingExcludeKeywordResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_keywords/%s", cfg.BackendUrl, input.ProductID, input.ID)

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

	result := model.UpdatePcKoubouCrawlSettingExcludeKeywordResultSuccess{
		Ok: true,
		PcKoubouCrawlSettingExcludeKeyword: &model.PcKoubouCrawlSettingExcludeKeyword{
			ID:                     strconv.Itoa(response.ID),
			PcKoubouCrawlSettingID: response.PcKoubouCrawlSettingID,
			Keyword:                response.Keyword,
			CreatedAt:              response.CreatedAt,
			UpdatedAt:              response.UpdatedAt,
		},
	}

	return result, nil
}

func (u *UpdatePcKoubouCrawlSettingExcludeKeywordService) handleServerError() model.UpdatePcKoubouCrawlSettingExcludeKeywordResultError {
	return model.UpdatePcKoubouCrawlSettingExcludeKeywordResultError{
		Ok: false,
		Error: model.UpdatePcKoubouCrawlSettingExcludeKeywordResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
