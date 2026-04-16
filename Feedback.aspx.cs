using System;
using System.Data;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class FeedbackPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20submit%20feedback.&toastType=info");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null && Request.QueryString["oid"] != null)
                {
                    hiddenPID.Value = Request.QueryString["pid"];
                    hiddenOID.Value = Request.QueryString["oid"];
                    LoadProductDetails(hiddenPID.Value);
                }
                else
                {
                    litProductName.Text = "HimVeda";
                }
            }
        }

        private void LoadProductDetails(string pid)
        {
            string sql = "SELECT ProductName FROM Products WHERE ProductID = @pid";
            object nameObj = DBHelper.ExecuteScalar(sql, new SqlParameter[] { new SqlParameter("@pid", pid) });
            if (nameObj != null)
            {
                litProductName.Text = nameObj.ToString();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int rating = 0;
            if (star5.Checked) rating = 5;
            else if (star4.Checked) rating = 4;
            else if (star3.Checked) rating = 3;
            else if (star2.Checked) rating = 2;
            else if (star1.Checked) rating = 1;

            if (rating == 0)
            {
                lblMessage.Text = "Please select a star rating.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            string satisfaction = string.IsNullOrEmpty(rdoListSatisfaction.SelectedValue) ? "Unknown" : rdoListSatisfaction.SelectedValue;
            string quality = string.IsNullOrEmpty(rdoListQuality.SelectedValue) ? "Unknown" : rdoListQuality.SelectedValue;
            string recommend = string.IsNullOrEmpty(rdoListRecommend.SelectedValue) ? "Unknown" : rdoListRecommend.SelectedValue;

            string rawComment = txtComment.Text.Trim();
            string finalComment = $"Satisfied: {satisfaction} | High Quality: {quality} | Recommend: {recommend} | Review: {rawComment}";

            if (!string.IsNullOrEmpty(hiddenPID.Value) && !string.IsNullOrEmpty(hiddenOID.Value))
            {
                // Check if already reviewed
                string checkSql = "SELECT COUNT(*) FROM Feedback WHERE OrderID = @oid AND ProductID = @pid AND UserID = @uid";
                int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkSql, new SqlParameter[] {
                    new SqlParameter("@oid", hiddenOID.Value),
                    new SqlParameter("@pid", hiddenPID.Value),
                    new SqlParameter("@uid", userId)
                }));

                if (count > 0)
                {
                    lblMessage.Text = "You have already reviewed this product for this order.";
                    lblMessage.CssClass = "badge badge-warning mb-4";
                    lblMessage.Visible = true;
                    btnSubmit.Enabled = false;
                    return;
                }

                // Insert Product Feedback
                string sql = "INSERT INTO Feedback (UserID, ProductID, OrderID, Rating, Comment) VALUES (@uid, @pid, @oid, @rat, @com)";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] {
                    new SqlParameter("@uid", userId),
                    new SqlParameter("@pid", hiddenPID.Value),
                    new SqlParameter("@oid", hiddenOID.Value),
                    new SqlParameter("@rat", rating),
                    new SqlParameter("@com", finalComment)
                });
            }
            else
            {
                // Insert General Feedback
                string sql = "INSERT INTO Feedback (UserID, Rating, Comment) VALUES (@uid, @rat, @com)";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] {
                    new SqlParameter("@uid", userId),
                    new SqlParameter("@rat", rating),
                    new SqlParameter("@com", finalComment)
                });
            }

            Response.Redirect("~/Default.aspx?toast=Feedback%20submitted%20successfully.&toastType=success");
        }
    }
}
