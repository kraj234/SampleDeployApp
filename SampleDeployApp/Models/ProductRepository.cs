namespace SampleDeployApp.Models
{
    public class ProductRepository : IProduct
    {
        public  Task<List<Product>> GetAllProductsAsync()
        {
            return Task.FromResult(SeedData.GetProducts());
        }
    }
}
