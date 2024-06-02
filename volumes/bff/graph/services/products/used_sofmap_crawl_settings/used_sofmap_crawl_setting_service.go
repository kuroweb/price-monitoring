package used_sofmap_crawl_settings

type IUsedSofmapCrawlSettingService interface {
	IFindUsedSofmapCrawlSettingService
}

type UsedSofmapCrawlSettingService struct {
	*FindUsedSofmapCrawlSettingService
}
