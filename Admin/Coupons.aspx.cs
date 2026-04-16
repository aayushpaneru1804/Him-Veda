using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class CouponsPage : System.Web.UI.Page
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
            string sql = "SELECT * FROM Coupons ORDER BY EndDate DESC";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvCoupons.DataSource = dt;
            gvCoupons.DataBind();

            // Stats
            int total = dt.Rows.Count;
            int active = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToBoolean(row["IsActive"])) active++;
            }
            litTotalCoupons.Text = total.ToString();
            litActiveCoupons.Text = active.ToString();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string idStr = hiddenCouponID.Value;
            string code = txtCode.Text.Trim().ToUpper();
            string type = ddlDiscountType.SelectedValue;
            decimal value = decimal.Parse(txtDiscountValue.Text);
            decimal minOrder = string.IsNullOrEmpty(txtMinOrder.Text) ? 0 : decimal.Parse(txtMinOrder.Text);
            DateTime start = DateTime.Parse(txtStartDate.Text);
            DateTime end = DateTime.Parse(txtEndDate.Text);
            bool isActive = chkIsActive.Checked;

            if (string.IsNullOrEmpty(idStr))
            {
                string checkSql = "SELECT * FROM Coupons WHERE Code=@code";
                if (DBHelper.ExecuteQuery(checkSql, new SqlParameter[] { new SqlParameter("@code", code) }).Rows.Count > 0)
                {
                    ShowMessage("Coupon Code already exists!", false);
                    return;
                }

                string insertSql = "INSERT INTO Coupons (Code, DiscountType, DiscountValue, MinOrderAmount, StartDate, EndDate, IsActive) VALUES (@code, @type, @val, @min, @start, @end, @active)";
                DBHelper.ExecuteNonQuery(insertSql, new SqlParameter[] {
                    new SqlParameter("@code", code),
                    new SqlParameter("@type", type),
                    new SqlParameter("@val", value),
                    new SqlParameter("@min", minOrder),
                    new SqlParameter("@start", start),
                    new SqlParameter("@end", end),
                    new SqlParameter("@active", isActive)
                });
                ShowMessage("Coupon created successfully!", true);
            }
            else
            {
                int cid = int.Parse(idStr);
                string updateSql = "UPDATE Coupons SET Code=@code, DiscountType=@type, DiscountValue=@val, MinOrderAmount=@min, StartDate=@start, EndDate=@end, IsActive=@active WHERE CouponID=@id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[] {
                    new SqlParameter("@code", code),
                    new SqlParameter("@type", type),
                    new SqlParameter("@val", value),
                    new SqlParameter("@min", minOrder),
                    new SqlParameter("@start", start),
                    new SqlParameter("@end", end),
                    new SqlParameter("@active", isActive),
                    new SqlParameter("@id", cid)
                });
                ShowMessage("Coupon updated successfully!", true);
            }

            btnClear_Click(null, null);
            LoadData();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            hiddenCouponID.Value = "";
            txtCode.Text = "";
            txtDiscountValue.Text = "";
            txtMinOrder.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            chkIsActive.Checked = true;
            litFormTitle.Text = "Add New Coupon";
            btnSave.Text = "Save Coupon";
        }

        protected void gvCoupons_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int cid = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCoupon")
            {
                DataTable dt = DBHelper.ExecuteQuery("SELECT * FROM Coupons WHERE CouponID=@id", new SqlParameter[] { new SqlParameter("@id", cid) });
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hiddenCouponID.Value = cid.ToString();
                    txtCode.Text = row["Code"].ToString();
                    ddlDiscountType.SelectedValue = row["DiscountType"].ToString();
                    txtDiscountValue.Text = row["DiscountValue"].ToString();
                    txtMinOrder.Text = row["MinOrderAmount"].ToString();
                    txtStartDate.Text = Convert.ToDateTime(row["StartDate"]).ToString("yyyy-MM-dd");
                    txtEndDate.Text = Convert.ToDateTime(row["EndDate"]).ToString("yyyy-MM-dd");
                    chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                    
                    litFormTitle.Text = "Edit Coupon";
                    btnSave.Text = "Update Coupon";
                }
            }
            else if (e.CommandName == "DeleteCoupon")
            {
                DBHelper.ExecuteNonQuery("UPDATE Orders SET CouponID = NULL WHERE CouponID = @id", new SqlParameter[] { new SqlParameter("@id", cid) });
                string sql = "DELETE FROM Coupons WHERE CouponID = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@id", cid) });
                ShowMessage("Coupon completely deleted.", false);
                LoadData();
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
