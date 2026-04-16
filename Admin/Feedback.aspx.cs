using System;
using System.Data;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class FeedbackPage : System.Web.UI.Page
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
                SELECT f.FeedbackID, f.Rating, f.Comment, f.FeedbackDate, u.FullName, p.ProductName 
                FROM Feedback f
                LEFT JOIN Users u ON f.UserID = u.UserID
                LEFT JOIN Products p ON f.ProductID = p.ProductID
                ORDER BY f.FeedbackDate DESC";
            
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvFeedback.DataSource = dt;
            gvFeedback.DataBind();
            
            litTotalFeedback.Text = dt.Rows.Count.ToString();
        }
        
        protected string GenerateStars(object ratingObj)
        {
            if (ratingObj == DBNull.Value || ratingObj == null)
            {
                return "<span style='color:#e2e8f0;'>★★★★★</span> <span style='font-size:0.8rem; color:#94a3b8;'>(No rating)</span>";
            }
            
            int rating = Convert.ToInt32(ratingObj);
            if (rating < 0) rating = 0;
            if (rating > 5) rating = 5;
            
            string filled = new string('★', rating);
            string empty = new string('★', 5 - rating);
            
            return $"{filled}<span style='color:#e2e8f0;'>{empty}</span>";
        }
    }
}
