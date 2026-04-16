using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class UsersPage : System.Web.UI.Page
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
            string sql = "SELECT UserID, FullName, Email, Phone, City, Password, CreatedAt, Status FROM Users ORDER BY CreatedAt DESC";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvUsers.DataSource = dt;
            gvUsers.DataBind();

            // Stats
            int total = dt.Rows.Count;
            int active = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (row["Status"].ToString() == "Active") active++;
            }
            litTotalUsers.Text = total.ToString();
            litActiveUsers.Text = active.ToString();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string idStr = hiddenUserID.Value;
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text.Trim();
            string city = txtCity.Text.Trim();
            string status = chkIsActive.Checked ? "Active" : "Inactive";

            if (string.IsNullOrEmpty(idStr))
            {
                // INSERT
                if (string.IsNullOrEmpty(password)) password = "password123"; // default fallback
                string checkSql = "SELECT * FROM Users WHERE Email=@email";
                if (DBHelper.ExecuteQuery(checkSql, new SqlParameter[] { new SqlParameter("@email", email) }).Rows.Count > 0)
                {
                    ShowMessage("Email already exists!", false);
                    return;
                }

                string insertSql = "INSERT INTO Users (FullName, Email, Phone, Password, City, CreatedAt, Status, Role) VALUES (@full, @email, @phone, @pass, @city, GETDATE(), @status, 'Customer')";
                DBHelper.ExecuteNonQuery(insertSql, new SqlParameter[] {
                    new SqlParameter("@full", fullName),
                    new SqlParameter("@email", email),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@pass", password),
                    new SqlParameter("@city", city),
                    new SqlParameter("@status", status)
                });
                ShowMessage("User added successfully!", true);
            }
            else
            {
                // UPDATE
                int uid = int.Parse(idStr);
                string updateSql = "UPDATE Users SET FullName=@full, Email=@email, Phone=@phone, City=@city, Status=@status WHERE UserID=@id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[] {
                    new SqlParameter("@full", fullName),
                    new SqlParameter("@email", email),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@city", city),
                    new SqlParameter("@status", status),
                    new SqlParameter("@id", uid)
                });

                if (!string.IsNullOrEmpty(password))
                {
                    DBHelper.ExecuteNonQuery("UPDATE Users SET Password=@pass WHERE UserID=@id", new SqlParameter[] {
                        new SqlParameter("@pass", password), new SqlParameter("@id", uid)
                    });
                }
                ShowMessage("User updated successfully!", true);
            }

            btnClear_Click(null, null);
            LoadData();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            hiddenUserID.Value = "";
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtCity.Text = "";
            txtPhone.Text = "";
            chkIsActive.Checked = true;
            litFormTitle.Text = "Add New User";
            btnSave.Text = "Save User";
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                DataTable dt = DBHelper.ExecuteQuery("SELECT * FROM Users WHERE UserID=@id", new SqlParameter[] { new SqlParameter("@id", userId) });
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hiddenUserID.Value = userId.ToString();
                    txtFullName.Text = row["FullName"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                    txtPhone.Text = row["Phone"].ToString();
                    txtCity.Text = row["City"].ToString();
                    chkIsActive.Checked = row["Status"].ToString() == "Active";
                    txtPassword.Text = ""; // don't show hash/pwd
                    
                    litFormTitle.Text = "Edit User";
                    btnSave.Text = "Update User";
                }
            }
            else if (e.CommandName == "DeleteUser")
            {
                DBHelper.ExecuteNonQuery("DELETE FROM CartItems WHERE CartID IN (SELECT CartID FROM Cart WHERE UserID = @id)", new SqlParameter[] { new SqlParameter("@id", userId) });
                DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE UserID = @id", new SqlParameter[] { new SqlParameter("@id", userId) });
                DBHelper.ExecuteNonQuery("DELETE FROM Wishlist WHERE UserID = @id", new SqlParameter[] { new SqlParameter("@id", userId) });
                DBHelper.ExecuteNonQuery("DELETE FROM Feedback WHERE UserID = @id", new SqlParameter[] { new SqlParameter("@id", userId) });
                
                string sql = "DELETE FROM Users WHERE UserID = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@id", userId) });
                
                ShowMessage("User completely deleted.", false);
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
