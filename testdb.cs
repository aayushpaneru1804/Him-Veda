using System;
using System.Data.SqlClient;
using System.Data;

class Program
{
    static void Main()
    {
        string connStr = "Data Source=.\SQLEXPRESS;Initial Catalog=HimVeda;Integrated Security=True;";
        
        try {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                Console.WriteLine("Connected.");
                string q = "SELECT AdminID, AdminName, Role FROM Admins WHERE Email = @Email AND Password = @Password AND Status = 'Active'";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", "admin@himveda.com");
                    cmd.Parameters.AddWithValue("@Password", "admin123");
                    using (SqlDataReader r = cmd.ExecuteReader()) { Console.WriteLine("Admin query OK"); }
                }

                string vendorSql = "SELECT VendorID, VendorName, Status FROM Vendors WHERE Email = @Email AND Password = @Password";
                using(SqlCommand cmd = new SqlCommand(vendorSql, conn)) {
                    cmd.Parameters.AddWithValue("@Email", "a@b.com");
                    cmd.Parameters.AddWithValue("@Password", "123");
                    using (SqlDataReader r = cmd.ExecuteReader()) { Console.WriteLine("Vendor query OK"); }
                }

                string userSql = "SELECT UserID, FullName, Status FROM Users WHERE Email = @Email AND Password = @Password";
                using(SqlCommand cmd = new SqlCommand(userSql, conn)) {
                    cmd.Parameters.AddWithValue("@Email", "a@b.com");
                    cmd.Parameters.AddWithValue("@Password", "123");
                    using (SqlDataReader r = cmd.ExecuteReader()) { Console.WriteLine("User query OK"); }
                }

                string cartSql = "SELECT ci.CartItemID, ci.Quantity, ci.UnitPrice, ci.SubTotal, p.ProductID, p.ProductName, p.MainImage FROM CartItems ci INNER JOIN Cart c ON ci.CartID = c.CartID INNER JOIN Products p ON ci.ProductID = p.ProductID WHERE c.UserID = @uid AND c.CartStatus = 'Active'";
                using(SqlCommand cmd = new SqlCommand(cartSql, conn)) {
                    cmd.Parameters.AddWithValue("@uid", 1);
                    using (SqlDataReader r = cmd.ExecuteReader()) { Console.WriteLine("Cart query OK"); }
                }
            }
        } catch (Exception ex) {
            Console.WriteLine("ERROR: " + ex.Message);
        }
    }
}
