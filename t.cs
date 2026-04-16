using System;
using System.Data.SqlClient;
using System.Data;

class Program {
    static void Main() {
        string cs = "Data Source=.\\SQLEXPRESS;Initial Catalog=HimVeda;Integrated Security=True;";
        try {
            Console.WriteLine("Starting...");
            DataTable dt = new DataTable();
            using(SqlConnection c = new SqlConnection(cs)) {
                using(SqlCommand cmd = new SqlCommand("SELECT TOP 1 * FROM Users", c)) {
                    using(SqlDataAdapter da = new SqlDataAdapter(cmd)) {
                        da.Fill(dt);
                    }
                }
            }
            Console.WriteLine("Success!");
        } catch (Exception ex) {
            Console.WriteLine(ex.ToString());
        }
    }
}
