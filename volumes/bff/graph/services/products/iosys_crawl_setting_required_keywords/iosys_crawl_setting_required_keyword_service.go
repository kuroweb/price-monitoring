package iosys_crawl_setting_required_keywords

type IIosysCrawlSettingRequiredKeywordService interface {
	IFindIosysCrawlSettingRequiredKeywordService
	ICreateIosysCrawlSettingRequiredKeywordService
	IUpdateIosysCrawlSettingRequiredKeywordService
	IDeleteIosysCrawlSettingRequiredKeywordService
}

type IosysCrawlSettingRequiredKeywordService struct {
	*FindIosysCrawlSettingRequiredKeywordService
	*CreateIosysCrawlSettingRequiredKeywordService
	*UpdateIosysCrawlSettingRequiredKeywordService
	*DeleteIosysCrawlSettingRequiredKeywordService
}
