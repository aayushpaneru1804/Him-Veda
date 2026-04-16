using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && (Request.QueryString["logout"] == "1" || Session["Role"] != null))
            {
                Session.Clear();
                FormsAuthentication.SignOut();
            }
            lblError.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                lblError.Text = "Please enter both email and password.";
                lblError.Visible = true;
                return;
            }

            try
            {
                // 🔹 Admin Login
                SqlParameter[] adminParams = new SqlParameter[]
                {
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Password", password)
                };

                string adminSql = @"SELECT AdminID, AdminName 
                                    FROM Admins 
                                    WHERE Email = @Email 
                                    AND Password = @Password 
                                    AND Status = 'Active'";

                DataTable dtAdmin = DBHelper.ExecuteQuery(adminSql, adminParams);

                if (dtAdmin.Rows.Count > 0)
                {
                    Session["Role"] = "Admin";
                    Session["AdminID"] = dtAdmin.Rows[0]["AdminID"];
                    Session["AdminName"] = dtAdmin.Rows[0]["AdminName"];

                    FormsAuthentication.SetAuthCookie(email, false);
                    Response.Redirect("~/Admin/Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // 🔹 User Login
                SqlParameter[] userParams = new SqlParameter[]
                {
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Password", password)
                };

                string userSql = @"SELECT UserID, FullName, Status 
                                   FROM Users 
                                   WHERE Email = @Email 
                                   AND Password = @Password";

                DataTable dtUser = DBHelper.ExecuteQuery(userSql, userParams);

                if (dtUser.Rows.Count > 0)
                {
                    if (Convert.ToBoolean(dtUser.Rows[0]["Status"]) == false)
                        {
                        lblError.Text = "Your account is currently inactive.";
                        lblError.Visible = true;
                        return;
                    }

                    Session["Role"] = "Customer";
                    Session["UserID"] = dtUser.Rows[0]["UserID"];
                    Session["FullName"] = dtUser.Rows[0]["FullName"];

                    FormsAuthentication.SetAuthCookie(email, false);
                    Response.Redirect("~/Default.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // ❌ Invalid login
                lblError.Text = "Invalid email or password.";
                lblError.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "Login Error: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}