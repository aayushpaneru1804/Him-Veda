using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Vendor
{
    public partial class OrdersPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vendor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);

            // Total Stats
            string statSql = @"
                SELECT COUNT(DISTINCT o.OrderID) as TotalOrders, SUM(oi.SubTotal) as TotalRevenue 
                FROM OrderItems oi
                JOIN Orders o ON oi.OrderID = o.OrderID
                WHERE oi.VendorID = @vid";
            
            DataTable dtStats = DBHelper.ExecuteQuery(statSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) });
            if (dtStats.Rows.Count > 0)
            {
                litTotalOrders.Text = dtStats.Rows[0]["TotalOrders"] == DBNull.Value ? "0" : dtStats.Rows[0]["TotalOrders"].ToString();
                litTotalRevenue.Text = dtStats.Rows[0]["TotalRevenue"] == DBNull.Value ? "Rs. 0" : Convert.ToDecimal(dtStats.Rows[0]["TotalRevenue"]).ToString("C");
            }

            // Grid
            string gridSql = @"
                SELECT oi.OrderItemID, o.OrderID, p.ProductName, oi.Quantity, oi.SubTotal, o.OrderDate, ISNULL(oi.OrderStatus, 'Pending') as OrderStatus 
                FROM OrderItems oi
                JOIN Orders o ON oi.OrderID = o.OrderID
                JOIN Products p ON oi.ProductID = p.ProductID
                WHERE oi.VendorID = @vid
                ORDER BY o.OrderDate DESC";
            
            DataTable dtGrid = DBHelper.ExecuteQuery(gridSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) });
            gvOrders.DataSource = dtGrid;
            gvOrders.DataBind();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int orderItemId = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
                DropDownList ddl = (DropDownList)row.FindControl("ddlStatus");
                string newStatus = ddl.SelectedValue;

                string sql = "UPDATE OrderItems SET OrderStatus = @status WHERE OrderItemID = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] {
                    new SqlParameter("@status", newStatus),
                    new SqlParameter("@id", orderItemId)
                });

                ClientScript.RegisterStartupScript(GetType(), "StatusUpdate", "alert('Order status updated successfully!');", true);
                LoadOrders();
            }
        }
    }
}
