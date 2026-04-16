using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            try
            {
                string sql = "SELECT FullName, Email, Phone, Address, ProfileImage FROM Users WHERE UserID = @UserID";
                SqlParameter[] pm = { new SqlParameter("@UserID", Session["UserID"]) };
                DataTable dt = DBHelper.ExecuteQuery(sql, pm);
                
                if (dt.Rows.Count > 0)
                {
                    txtName.Text = dt.Rows[0]["FullName"].ToString();
                    txtEmail.Text = dt.Rows[0]["Email"].ToString();
                    txtPhone.Text = dt.Rows[0]["Phone"].ToString();
                    txtAddress.Text = dt.Rows[0]["Address"].ToString();
                    
                    string profileImg = dt.Rows[0]["ProfileImage"].ToString();
                    if (!string.IsNullOrEmpty(profileImg))
                    {
                        imgAvatar.ImageUrl = "~/Images/Users/" + profileImg;
                    }
                    else
                    {
                        imgAvatar.ImageUrl = "~/Images/default-avatar.png";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading profile: " + ex.Message;
                lblMessage.BackColor = System.Drawing.Color.LightCoral;
                lblMessage.Visible = true;
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                lblMessage.Text = "Name is required.";
                lblMessage.BackColor = System.Drawing.Color.LightCoral;
                lblMessage.Visible = true;
                return;
            }

            try
            {
                string profileImageName = "";
                if (fileProfileImage.HasFile)
                {
                    string ext = Path.GetExtension(fileProfileImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
                    {
                        string uploadDir = Server.MapPath("~/Images/Users/");
                        if (!Directory.Exists(uploadDir)) Directory.CreateDirectory(uploadDir);

                        profileImageName = "user_" + Session["UserID"] + "_" + DateTime.Now.Ticks + ext;
                        fileProfileImage.SaveAs(Path.Combine(uploadDir, profileImageName));
                    }
                }

                string sql;
                SqlParameter[] pm;
                
                if (!string.IsNullOrEmpty(profileImageName))
                {
                    sql = "UPDATE Users SET FullName = @FullName, Phone = @Phone, Address = @Address, ProfileImage = @ProfileImage WHERE UserID = @UserID";
                    pm = new SqlParameter[] {
                        new SqlParameter("@FullName", txtName.Text.Trim()),
                        new SqlParameter("@Phone", txtPhone.Text.Trim()),
                        new SqlParameter("@Address", txtAddress.Text.Trim()),
                        new SqlParameter("@ProfileImage", profileImageName),
                        new SqlParameter("@UserID", Session["UserID"])
                    };
                }
                else
                {
                    sql = "UPDATE Users SET FullName = @FullName, Phone = @Phone, Address = @Address WHERE UserID = @UserID";
                    pm = new SqlParameter[] {
                        new SqlParameter("@FullName", txtName.Text.Trim()),
                        new SqlParameter("@Phone", txtPhone.Text.Trim()),
                        new SqlParameter("@Address", txtAddress.Text.Trim()),
                        new SqlParameter("@UserID", Session["UserID"])
                    };
                }

                int rows = DBHelper.ExecuteNonQuery(sql, pm);
                
                if (rows > 0)
                {
                    Session["FullName"] = txtName.Text.Trim(); // update session name
                    Response.Redirect("~/Default.aspx?toast=Profile%20updated%20successfully.&toastType=success");
                    return;
                }
                else
                {
                    lblMessage.Text = "Failed to update profile.";
                    lblMessage.BackColor = System.Drawing.Color.LightCoral;
                    lblMessage.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error updating profile: " + ex.Message;
                lblMessage.BackColor = System.Drawing.Color.LightCoral;
                lblMessage.Visible = true;
            }
        }
    }
}
