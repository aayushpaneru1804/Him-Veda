using System;
using System.Data;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFeaturedProducts();
                LoadSpecialOffers();
                LoadTestimonials();
            }
        }

        private void LoadFeaturedProducts()
        {
            // Load latest 8 featured and active products
            string sql = "SELECT TOP 12 ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 AND IsFeatured = 1 ORDER BY CreatedAt DESC";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            rptFeatured.DataSource = dt;
            rptFeatured.DataBind();
        }

        private void LoadSpecialOffers()
        {
            // Load latest 4 products under 1000 dynamically to act as offers
            string sql = "SELECT TOP 4 ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 AND Price < 1000 ORDER BY NEWID()";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            rptOffers.DataSource = dt;
            rptOffers.DataBind();
        }

        private void LoadTestimonials()
        {
            // Load latest 3 highly rated feedback entries
            string sql = @"
                SELECT TOP 3 f.Rating, f.Comment, u.FullName, u.UserID, u.ProfileImage 
                FROM Feedback f 
                INNER JOIN Users u ON f.UserID = u.UserID 
                WHERE f.Rating >= 4 
                ORDER BY f.FeedbackDate DESC, NEWID()";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            rptTestimonials.DataSource = dt;
            rptTestimonials.DataBind();
        }

        protected string GetStars(int rating)
        {
            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;
            return new string('★', rating) + new string('☆', 5 - rating);
        }

        protected string GetProfileImage(object profileObj)
        {
            if (profileObj != null && profileObj != DBNull.Value && !string.IsNullOrEmpty(profileObj.ToString()))
            {
                return "~/Images/Users/" + profileObj.ToString();
            }
            return "~/Images/default-avatar.png";
        }

        protected void rptFeatured_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "View")
            {
                Response.Redirect("~/ProductDetails.aspx?id=" + productId);
            }
            else if (e.CommandName == "AddCart")
            {
                // We'll implement Cart logic slightly later. For now, redirect to login if not logged in.
                if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
                {
                    Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20add%20items%20to%20cart.&toastType=info");
                }
                else
                {
                    // Add to cart directly
                    int userId = Convert.ToInt32(Session["UserID"]);
                    CartHelper.AddToCart(userId, productId, 1);
                    Response.Redirect("~/Cart.aspx");
                }
            }
        }
    }
}
