using System;
using System.Data;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda.Vendor
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vendor")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                litVendorName.Text = Session["VendorName"].ToString();
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);

            // Total Products
            string prodSql = "SELECT COUNT(*) FROM Products WHERE VendorID = @vid";
            litTotalProducts.Text = Convert.ToInt32(DBHelper.ExecuteScalar(prodSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) })).ToString();

            // Total Orders
            string orderSql = "SELECT COUNT(DISTINCT OrderID) FROM OrderItems WHERE VendorID = @vid";
            litTotalOrders.Text = Convert.ToInt32(DBHelper.ExecuteScalar(orderSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) })).ToString();

            // Total Revenue
            string revSql = "SELECT ISNULL(SUM(SubTotal), 0) FROM OrderItems WHERE VendorID = @vid";
            decimal rev = Convert.ToDecimal(DBHelper.ExecuteScalar(revSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) }));
            litTotalRevenue.Text = rev.ToString("C");
        }
    }
}
