package products

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

type ICreateProductService interface {
	CreateProduct(ctx context.Context, input model.CreateProductInput) (model.CreateProductResult, error)
}

type CreateProductService struct{}

func (c *CreateProductService) CreateProduct(ctx context.Context, input model.CreateProductInput) (model.CreateProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products", cfg.BackendUrl)

	body := map[string]interface{}{
		"name": input.Name,
		"yahoo_auction_crawl_setting": map[string]interface{}{
			"keyword":     input.YahooAuctionCrawlSetting.Keyword,
			"category_id": input.YahooAuctionCrawlSetting.CategoryID,
			"min_price":   input.YahooAuctionCrawlSetting.MinPrice,
			"max_price":   input.YahooAuctionCrawlSetting.MaxPrice,
			"enabled":     input.YahooAuctionCrawlSetting.Enabled,
		},
		"mercari_crawl_setting": map[string]interface{}{
			"keyword":     input.MercariCrawlSetting.Keyword,
			"category_id": input.MercariCrawlSetting.CategoryID,
			"min_price":   input.MercariCrawlSetting.MinPrice,
			"max_price":   input.MercariCrawlSetting.MaxPrice,
			"enabled":     input.MercariCrawlSetting.Enabled,
		},
		"janpara_crawl_setting": map[string]interface{}{
			"keyword":   input.JanparaCrawlSetting.Keyword,
			"min_price": input.JanparaCrawlSetting.MinPrice,
			"max_price": input.JanparaCrawlSetting.MaxPrice,
			"enabled":   input.JanparaCrawlSetting.Enabled,
		},
		"iosys_crawl_setting": map[string]interface{}{
			"keyword":   input.IosysCrawlSetting.Keyword,
			"min_price": input.IosysCrawlSetting.MinPrice,
			"max_price": input.IosysCrawlSetting.MaxPrice,
			"enabled":   input.IosysCrawlSetting.Enabled,
		},
		"pc_koubou_crawl_setting": map[string]interface{}{
			"keyword":   input.PcKoubouCrawlSetting.Keyword,
			"min_price": input.PcKoubouCrawlSetting.MinPrice,
			"max_price": input.PcKoubouCrawlSetting.MaxPrice,
			"enabled":   input.PcKoubouCrawlSetting.Enabled,
		},
	}

	requestBody, err := json.Marshal(body)
	if err != nil {
		return c.handleServerError(), nil
	}

	// POSTリクエストの作成
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return c.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.handleServerError(), nil
	}

	var response struct {
		ID   int    `json:"id"`
		Name string `json:"name"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return c.handleServerError(), nil
	}

	result := model.CreateProductResultSuccess{
		Ok: true,
		Product: &model.Product{
			ID:   strconv.Itoa(response.ID),
			Name: response.Name,
		},
	}

	return result, nil
}

func (c *CreateProductService) handleServerError() model.CreateProductResultError {
	return model.CreateProductResultError{
		Ok: false,
		Error: model.CreateProductResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
