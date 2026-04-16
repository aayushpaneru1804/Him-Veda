using System;
using System.Data.SqlClient;
using System.Data;
class Program {
    static void Main() {
        string connStr = "Data Source=.\SQLEXPRESS;Initial Catalog=HimVeda;Integrated Security=True;";
        try {
            using(SqlConnection conn = new SqlConnection(connStr)) {
                conn.Open();
                Console.WriteLine("Connected.");
                
                string email = "sugampaudel@email.com";
                string password = "123456789";
                
                SqlParameter[] p = new SqlParameter[] {
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Password", password)
                };
                string vendorSql = "SELECT VendorID, VendorName, Status FROM Vendors WHERE Email = @Email AND Password = @Password";
                using(SqlCommand cmd = new SqlCommand(vendorSql, conn)) {
                    cmd.Parameters.AddRange(p);
                    using(SqlDataReader r = cmd.ExecuteReader()) {
                        if(r.Read()) Console.WriteLine("Vendor logged in: " + r["VendorName"].ToString());
                        else Console.WriteLine("Vendor not found");
                    }
                }
            }
        } catch (Exception ex) { Console.WriteLine(ex.Message); }
    }
}
