package products

type IProductService interface {
	IFindService
}

type ProductService struct {
	*FindService
}

func New() IProductService {
	return &ProductService{
		FindService: &FindService{},
	}
}
