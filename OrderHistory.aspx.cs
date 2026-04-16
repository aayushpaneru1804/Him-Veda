using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class OrderHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20view%20order%20history.&toastType=info");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string sql = "SELECT * FROM Orders WHERE UserID = @uid ORDER BY OrderDate DESC";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@uid", userId) });

            if (dt.Rows.Count > 0)
            {
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
                rptOrders.Visible = true;
            }
            else
            {
                rptOrders.Visible = false;
                lblMessage.Text = "You have no orders yet.";
                lblMessage.Visible = true;
            }
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptItems = (Repeater)e.Item.FindControl("rptItems");
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                
                int orderId = Convert.ToInt32(rowView["OrderID"]);
                // Use a little trick: send the parent OrderStatus into the child query so we can evaluate it for feedback
                string status = rowView["OrderStatus"].ToString();

                string sqlItems = @"
                    SELECT oi.*, p.ProductName, @stat as OrderStatus
                    FROM OrderItems oi
                    INNER JOIN Products p ON oi.ProductID = p.ProductID
                    WHERE oi.OrderID = @oid";

                DataTable dtItems = DBHelper.ExecuteQuery(sqlItems, new SqlParameter[] { 
                    new SqlParameter("@oid", orderId),
                    new SqlParameter("@stat", status)
                });

                rptItems.DataSource = dtItems;
                rptItems.DataBind();
            }
        }
    }
}
