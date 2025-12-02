namespace SampleDeployApp.Models
{
    public class ProductService
    {
        private readonly IProduct _productRepository;
        public ProductService(IProduct product)
        {
                _productRepository = product;
        }
        public Task<List<Product>> GetAllProductsAsync()
        {
            return _productRepository.GetAllProductsAsync();
        }
    }
}
