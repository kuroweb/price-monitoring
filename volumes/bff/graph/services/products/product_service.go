package products

type IProductService interface {
	IFindService
	IDeleteService
}

type ProductService struct {
	*FindService
	*DeleteService
}

func New() IProductService {
	return &ProductService{
		FindService:   &FindService{},
		DeleteService: &DeleteService{},
	}
}
