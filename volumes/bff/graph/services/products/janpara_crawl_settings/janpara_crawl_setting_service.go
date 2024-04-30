package janpara_crawl_settings

type IJanparaCrawlSettingService interface {
	IFindJanparaCrawlSettingService
}

type JanparaCrawlSettingService struct {
	*FindJanparaCrawlSettingService
}
