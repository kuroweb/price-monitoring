package iosys_crawl_settings

type IIosysCrawlSettingService interface {
	IFindIosysCrawlSettingService
}

type IosysCrawlSettingService struct {
	*FindIosysCrawlSettingService
}
