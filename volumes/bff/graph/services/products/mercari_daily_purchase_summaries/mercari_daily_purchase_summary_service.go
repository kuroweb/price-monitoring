package mercari_daily_purchase_summaries

type IMercariDailyPurchaseSummaryService interface {
	IFindMercariDailyPurchaseSummaryService
}

type MercariDailyPurchaseSummaryService struct {
	*FindMercariDailyPurchaseSummaryService
}
