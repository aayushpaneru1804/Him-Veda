using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class VendorsPage : System.Web.UI.Page
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
            string sql = "SELECT * FROM Vendors ORDER BY JoinedAt DESC";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvVendors.DataSource = dt;
            gvVendors.DataBind();

            // Stats
            int total = dt.Rows.Count;
            int pending = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (row["Status"].ToString() == "Pending") pending++;
            }
            litTotalVendors.Text = total.ToString();
            litPendingVendors.Text = pending.ToString();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string idStr = hiddenVendorID.Value;
            string business = txtBusinessName.Text.Trim();
            string contact = txtVendorName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string status = ddlStatus.SelectedValue;

            if (string.IsNullOrEmpty(idStr))
            {
                if (string.IsNullOrEmpty(password)) password = "vendorpassword123";
                
                string checkSql = "SELECT * FROM Vendors WHERE Email=@email";
                if (DBHelper.ExecuteQuery(checkSql, new SqlParameter[] { new SqlParameter("@email", email) }).Rows.Count > 0)
                {
                    ShowMessage("Vendor email already exists!", false);
                    return;
                }

                string insertSql = "INSERT INTO Vendors (VendorName, BusinessName, Email, Phone, Password, BusinessAddress, JoinedAt, Status) VALUES (@contact, @biz, @email, @phone, @pass, @addr, GETDATE(), @status)";
                DBHelper.ExecuteNonQuery(insertSql, new SqlParameter[] {
                    new SqlParameter("@contact", contact),
                    new SqlParameter("@biz", business),
                    new SqlParameter("@email", email),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@pass", password),
                    new SqlParameter("@addr", address),
                    new SqlParameter("@status", status)
                });
                ShowMessage("Vendor created successfully!", true);
            }
            else
            {
                int vid = int.Parse(idStr);
                string updateSql = "UPDATE Vendors SET VendorName=@contact, BusinessName=@biz, Email=@email, Phone=@phone, BusinessAddress=@addr, Status=@status WHERE VendorID=@id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[] {
                    new SqlParameter("@contact", contact),
                    new SqlParameter("@biz", business),
                    new SqlParameter("@email", email),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@addr", address),
                    new SqlParameter("@status", status),
                    new SqlParameter("@id", vid)
                });

                if (!string.IsNullOrEmpty(password))
                {
                    DBHelper.ExecuteNonQuery("UPDATE Vendors SET Password=@pass WHERE VendorID=@id", new SqlParameter[] {
                        new SqlParameter("@pass", password), new SqlParameter("@id", vid)
                    });
                }
                ShowMessage("Vendor updated successfully!", true);
            }

            btnClear_Click(null, null);
            LoadData();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            hiddenVendorID.Value = "";
            txtBusinessName.Text = "";
            txtVendorName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            ddlStatus.SelectedValue = "Approved";
            litFormTitle.Text = "Add New Vendor";
            btnSave.Text = "Save Vendor";
        }

        protected void gvVendors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int vendorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditVendor")
            {
                DataTable dt = DBHelper.ExecuteQuery("SELECT * FROM Vendors WHERE VendorID=@id", new SqlParameter[] { new SqlParameter("@id", vendorId) });
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hiddenVendorID.Value = vendorId.ToString();
                    txtBusinessName.Text = row["BusinessName"].ToString();
                    txtVendorName.Text = row["VendorName"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                    txtPhone.Text = row["Phone"].ToString();
                    txtAddress.Text = row["BusinessAddress"].ToString();
                    ddlStatus.SelectedValue = row["Status"].ToString();
                    txtPassword.Text = "";
                    
                    litFormTitle.Text = "Edit Vendor";
                    btnSave.Text = "Update Vendor";
                }
            }
            else if (e.CommandName == "ApproveVendor")
            {
                string sql = "UPDATE Vendors SET Status = 'Approved' WHERE VendorID = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@id", vendorId) });
                ShowMessage("Vendor Approved successfully.", true);
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
