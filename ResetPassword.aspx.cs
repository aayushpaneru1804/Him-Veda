using System;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ResetEmail"] == null)
            {
                // Prevent direct access to this page
                Response.Redirect("~/Login.aspx");
            }
            lblMessage.Visible = false;
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (Session["ResetEmail"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string email = Session["ResetEmail"].ToString();
            string newPassword = txtNewPassword.Text; // Expected to be 6+ length due to validator

            string sql = "UPDATE Users SET Password = @Password WHERE Email = @Email";
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Password", newPassword), // Note: Hash in production!
                new SqlParameter("@Email", email)
            };

            try
            {
                DBHelper.ExecuteNonQuery(sql, parameters);
                
                // Clear the session as reset is complete
                Session.Remove("ResetEmail");
                
                // Redirect user to login with success message
                Response.Redirect("~/Login.aspx?toast=Password%20reset%20successfully.%20Please%20login.&toastType=success");
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
                lblMessage.Visible = true;
            }
        }
    }
}
