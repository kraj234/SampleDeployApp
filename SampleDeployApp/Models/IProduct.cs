namespace SampleDeployApp.Models
{
    public interface IProduct
    {
        Task<List<Product>> GetAllProductsAsync();
    }
}
