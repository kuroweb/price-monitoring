package yahoo_auction_crawl_setting_exclude_products

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IFindYahooAuctionCrawlSettingExcludeProductService interface {
	FindYahooAuctionCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingExcludeProduct, error)
}

type FindYahooAuctionCrawlSettingExcludeProductService struct{}

func (f *FindYahooAuctionCrawlSettingExcludeProductService) FindYahooAuctionCrawlSettingExcludeProduct(ctx context.Context, productID int, yahooAuctionCrawlSettingID string) ([]*model.YahooAuctionCrawlSettingExcludeProduct, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_products", cfg.BackendUrl, strconv.Itoa(productID))

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to fetch yahoo_auction_crawl_setting_exclude_product data")
	}

	var response struct {
		ExcludeProducts []struct {
			ID                         int    `json:"id"`
			YahooAuctionCrawlSettingID int    `json:"yahoo_auction_crawl_setting_id"`
			ExternalID                 string `json:"external_id"`
			UpdatedAt                  string `json:"updated_at"`
			CreatedAt                  string `json:"created_at"`
		} `json:"yahoo_auction_crawl_setting_exclude_products"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	ExcludeProducts := make([]*model.YahooAuctionCrawlSettingExcludeProduct, len(response.ExcludeProducts))
	for i, ExcludeProduct := range response.ExcludeProducts {
		ExcludeProducts[i] = &model.YahooAuctionCrawlSettingExcludeProduct{
			ID:                         strconv.Itoa(ExcludeProduct.ID),
			YahooAuctionCrawlSettingID: ExcludeProduct.YahooAuctionCrawlSettingID,
			ExternalID:                 ExcludeProduct.ExternalID,
			UpdatedAt:                  ExcludeProduct.UpdatedAt,
			CreatedAt:                  ExcludeProduct.CreatedAt,
		}
	}

	return ExcludeProducts, nil
}
