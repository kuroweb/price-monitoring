package related_products

type IRelatedProductService interface {
	IFindRelatedProductService
}

type RelatedProductService struct {
	*FindRelatedProductService
}
