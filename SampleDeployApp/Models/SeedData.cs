namespace SampleDeployApp.Models
{
    public static class SeedData
    {
        public  static List<Product> GetProducts()
        {
            return new List<Product>
            {
                new Product
                {
                    Name = "Sample Product 1",
                    Description = "This is a description for Sample Product 1.",
                    Price = 19.99m,
                    StockQuantity = 100
                },
                new Product
                {
                    Name = "Sample Product 2",
                    Description = "This is a description for Sample Product 2.",
                    Price = 29.99m,
                    StockQuantity = 150
                },
                new Product
                {
                    Name = "Sample Product 3",
                    Description = "This is a description for Sample Product 3.",
                    Price = 39.99m,
                    StockQuantity = 200
                }
            };
        }
    }
}
