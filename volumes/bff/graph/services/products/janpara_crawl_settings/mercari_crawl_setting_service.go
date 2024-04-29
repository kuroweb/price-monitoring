package mercari_crawl_settings

type IMercariCrawlSettingService interface {
	IFindMercariCrawlSettingService
}

type MercariCrawlSettingService struct {
	*FindMercariCrawlSettingService
}
