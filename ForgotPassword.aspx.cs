using System;
using System.Data;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            
            // Clear any lingering session from before
            if (!IsPostBack)
            {
                Session.Remove("ResetEmail");
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email))
            {
                ShowError("Please enter your email address.");
                return;
            }

            string sql = "SELECT SecurityQuestion FROM Users WHERE Email = @Email";
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Email", email)
            };

            // First check if the user even exists 
            string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            int exists = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, new SqlParameter[] { new SqlParameter("@Email", email) }));

            if (exists > 0)
            {
                object result = DBHelper.ExecuteScalar(sql, parameters);
                string securityQuestion = (result != null && result != DBNull.Value) ? result.ToString() : string.Empty;
                
                // If they registered but somehow have no security question setup
                if (string.IsNullOrWhiteSpace(securityQuestion))
                {
                    ShowError("This account was created before security questions were required. Please contact support or register a new account to test.");
                    return;
                }

                // Move to Step 2
                lblSecurityQuestion.Text = securityQuestion;
                ViewState["ResetEmail"] = email;
                
                pnlStep1.Visible = false;
                pnlStep2.Visible = true;
            }
            else
            {
                ShowError("Invalid details. We could not find that email address.");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (ViewState["ResetEmail"] == null)
            {
                ShowError("Session expired. Please start over.");
                lnkBack_Click(null, null);
                return;
            }

            string email = ViewState["ResetEmail"].ToString();
            string answer = txtSecurityAnswer.Text.Trim();
            string dob = txtDOB.Text; // Expected format: yyyy-MM-dd from textmode="date"

            string sql = "SELECT UserID FROM Users WHERE Email = @Email AND SecurityAnswer = @Answer AND DateOfBirth = @DOB";
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Email", email),
                new SqlParameter("@Answer", answer),
                new SqlParameter("@DOB", dob)
            };

            object result = DBHelper.ExecuteScalar(sql, parameters);

            if (result != null)
            {
                // Verification successful
                Session["ResetEmail"] = email;
                Response.Redirect("~/ResetPassword.aspx");
            }
            else
            {
                // Invalid DOB or Answer
                ShowError("Invalid details. Please try again.");
            }
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            ViewState.Remove("ResetEmail");
            txtSecurityAnswer.Text = "";
            txtDOB.Text = "";
            pnlStep1.Visible = true;
            pnlStep2.Visible = false;
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}
