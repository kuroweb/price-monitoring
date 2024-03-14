package mercari_products

type IMercariProductService interface {
	IFindMercariProductService
}

type MercariProductService struct {
	*FindMercariProductService
}
