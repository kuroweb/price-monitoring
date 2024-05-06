package pc_koubou_crawl_settings

type IPcKoubouCrawlSettingService interface {
	IFindPcKoubouCrawlSettingService
}

type PcKoubouCrawlSettingService struct {
	*FindPcKoubouCrawlSettingService
}
