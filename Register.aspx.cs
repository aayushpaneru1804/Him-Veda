using System;
using System.Data.SqlClient;
using System.IO;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            lblSuccess.Visible = false;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string regType = hiddenRegType.Value;

            try
            {
                if (regType == "customer")
                {
                    RegisterCustomer();
                }
                else if (regType == "vendor")
                {
                    RegisterVendor();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Registration failed. Error: " + ex.Message;
                lblMessage.Visible = true;
            }
        }

        private void RegisterCustomer()
        {
            if (string.IsNullOrWhiteSpace(txtCustName.Text) || string.IsNullOrWhiteSpace(txtCustEmail.Text) || string.IsNullOrWhiteSpace(txtCustPassword.Text) || string.IsNullOrWhiteSpace(txtCustDOB.Text) || string.IsNullOrWhiteSpace(ddlCustSecQuestion.SelectedValue) || string.IsNullOrWhiteSpace(txtCustSecAnswer.Text))
            {
                lblMessage.Text = "Please fill in all required fields (including DOB and Security Question).";
                lblMessage.Visible = true;
                return;
            }

            // Check if email exists
            string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, new SqlParameter[] { new SqlParameter("@Email", txtCustEmail.Text.Trim()) }));

            if (count > 0)
            {
                lblMessage.Text = "Email is already registered.";
                lblMessage.Visible = true;
                return;
            }

            string profileImageName = "";
            if (fuCustProfileImage.HasFile)
            {
                string ext = Path.GetExtension(fuCustProfileImage.FileName).ToLower();
                if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp")
                {
                    string uploadDir = Server.MapPath("~/Images/Users/");
                    if (!Directory.Exists(uploadDir)) Directory.CreateDirectory(uploadDir);

                    profileImageName = "reg_" + DateTime.Now.Ticks + ext;
                    fuCustProfileImage.SaveAs(Path.Combine(uploadDir, profileImageName));
                }
            }

            string sql = "INSERT INTO Users (FullName, Email, Phone, Password, ProfileImage, DateOfBirth, SecurityQuestion, SecurityAnswer) VALUES (@Name, @Email, @Phone, @Pass, @ProfileImage, @Dob, @SecQ, @SecA)";
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Name", txtCustName.Text.Trim()),
                new SqlParameter("@Email", txtCustEmail.Text.Trim()),
                new SqlParameter("@Phone", txtCustPhone.Text.Trim()),
                new SqlParameter("@Pass", txtCustPassword.Text), // Note: In production use hashing like BCrypt!
                new SqlParameter("@ProfileImage", string.IsNullOrEmpty(profileImageName) ? (object)DBNull.Value : profileImageName),
                new SqlParameter("@Dob", txtCustDOB.Text),
                new SqlParameter("@SecQ", ddlCustSecQuestion.SelectedValue),
                new SqlParameter("@SecA", txtCustSecAnswer.Text.Trim())
            };

            DBHelper.ExecuteNonQuery(sql, parameters);
            // Redirect user to login page after successful registration
            Response.Redirect("~/Login.aspx?toast=Registration%20successful.%20Please%20login.&toastType=success");
        }

        private void RegisterVendor()
        {
            if (string.IsNullOrWhiteSpace(txtVendName.Text) || string.IsNullOrWhiteSpace(txtVendEmail.Text) || string.IsNullOrWhiteSpace(txtVendPassword.Text) || string.IsNullOrWhiteSpace(txtBusinessName.Text))
            {
                lblMessage.Text = "Please fill in all required fields.";
                lblMessage.Visible = true;
                return;
            }

            // Check if email exists
            string checkSql = "SELECT COUNT(*) FROM Vendors WHERE Email = @Email";
            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, new SqlParameter[] { new SqlParameter("@Email", txtVendEmail.Text.Trim()) }));

            if (count > 0)
            {
                lblMessage.Text = "Email is already registered.";
                lblMessage.Visible = true;
                return;
            }

            string sql = "INSERT INTO Vendors (VendorName, BusinessName, Email, Phone, Password, Status) VALUES (@Name, @BizName, @Email, @Phone, @Pass, 'Approved')";
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@Name", txtVendName.Text.Trim()),
                new SqlParameter("@BizName", txtBusinessName.Text.Trim()),
                new SqlParameter("@Email", txtVendEmail.Text.Trim()),
                new SqlParameter("@Phone", txtVendPhone.Text.Trim()),
                new SqlParameter("@Pass", txtVendPassword.Text) // Note: In production use hashing like BCrypt!
            };

            DBHelper.ExecuteNonQuery(sql, parameters);
            // Redirect vendor to login page after successful registration
            Response.Redirect("~/Login.aspx?toast=Vendor%20registration%20successful.%20Please%20login.&toastType=success");
        }
    }
}
