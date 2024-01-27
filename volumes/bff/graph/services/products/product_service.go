package products

type IProductService interface {
	IFindService
	IDeleteService
	ICreateService
}

type ProductService struct {
	*FindService
	*DeleteService
	*CreateService
}

func New() IProductService {
	return &ProductService{
		FindService:   &FindService{},
		DeleteService: &DeleteService{},
		CreateService: &CreateService{},
	}
}
