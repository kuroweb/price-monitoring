package used_sofmap_crawl_setting_exclude_products

type IUsedSofmapCrawlSettingExcludeProductService interface {
	IFindUsedSofmapCrawlSettingExcludeProductService
	ICreateUsedSofmapCrawlSettingExcludeProductService
	IUpdateUsedSofmapCrawlSettingExcludeProductService
	IDeleteUsedSofmapCrawlSettingExcludeProductService
}

type UsedSofmapCrawlSettingExcludeProductService struct {
	*FindUsedSofmapCrawlSettingExcludeProductService
	*CreateUsedSofmapCrawlSettingExcludeProductService
	*UpdateUsedSofmapCrawlSettingExcludeProductService
	*DeleteUsedSofmapCrawlSettingExcludeProductService
}