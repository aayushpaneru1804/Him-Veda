using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class OrdersPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            string sql = @"
                SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentMethod, u.FullName 
                FROM Orders o
                LEFT JOIN Users u ON o.UserID = u.UserID
                ORDER BY o.OrderDate DESC";
            
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvOrders.DataSource = dt;
            gvOrders.DataBind();

            // Stats
            int total = dt.Rows.Count;
            decimal rev = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (row["OrderStatus"].ToString() == "Delivered" && row["TotalAmount"] != DBNull.Value)
                {
                    rev += Convert.ToDecimal(row["TotalAmount"]);
                }
            }
            litTotalOrders.Text = total.ToString();
            litTotalRevenue.Text = "Rs. " + rev.ToString("N2");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string idStr = hiddenOrderID.Value;
            string status = ddlStatus.SelectedValue;

            if (!string.IsNullOrEmpty(idStr))
            {
                int oid = int.Parse(idStr);
                string updateSql = "UPDATE Orders SET OrderStatus=@status WHERE OrderID=@id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[] {
                    new SqlParameter("@status", status),
                    new SqlParameter("@id", oid)
                });
                ShowMessage("Order Status updated successfully!", true);
            }

            btnClear_Click(null, null);
            LoadData();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            hiddenOrderID.Value = "";
            txtOrderID.Text = "";
            txtCustomerName.Text = "";
            ddlStatus.SelectedValue = "Pending";
            btnSave.Enabled = false;
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditOrder")
            {
                int oid = Convert.ToInt32(e.CommandArgument);
                string sql = "SELECT o.OrderID, o.OrderStatus, u.FullName FROM Orders o LEFT JOIN Users u ON o.UserID = u.UserID WHERE OrderID=@id";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@id", oid) });
                
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hiddenOrderID.Value = oid.ToString();
                    txtOrderID.Text = row["OrderID"].ToString();
                    txtCustomerName.Text = row["FullName"].ToString();
                    ddlStatus.SelectedValue = row["OrderStatus"].ToString();
                    btnSave.Enabled = true;
                }
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = isSuccess ? "badge badge-success mb-4" : "badge badge-warning mb-4";
            lblMessage.Visible = true;
        }
    }
}
