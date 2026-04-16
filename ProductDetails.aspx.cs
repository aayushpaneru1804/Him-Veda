using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        private int _productId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                int.TryParse(Request.QueryString["id"], out _productId);
            }

            if (_productId == 0)
            {
                lblError.Text = "Product not found.";
                lblError.Visible = true;
                pnlDetails.Visible = false;
                return;
            }

            if (!IsPostBack)
            {
                LoadProductDetails();
                LoadVariations();
            }
        }

        private void LoadVariations()
        {
            string sql = @"
                SELECT VariationID, 
                       LTRIM(RTRIM(CONCAT(ISNULL(Size, ''), ' ', ISNULL(Color, ''), 
                       CASE WHEN AdditionalPrice > 0 THEN CONCAT(' (+Rs ', AdditionalPrice, ')') ELSE '' END))) AS VariationName 
                FROM ProductVariations WHERE ProductID = @pid";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@pid", _productId) });
            if (dt.Rows.Count > 0)
            {
                pnlVariations.Visible = true;
                ddlVariations.DataSource = dt;
                ddlVariations.DataTextField = "VariationName";
                ddlVariations.DataValueField = "VariationID";
                ddlVariations.DataBind();
                ddlVariations.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select a variation --", "0"));
            }
        }

        protected void ddlVariations_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sql = "SELECT Price FROM Products WHERE ProductID = @pid";
            decimal basePrice = Convert.ToDecimal(DBHelper.ExecuteScalar(sql, new SqlParameter[] { new SqlParameter("@pid", _productId) }));
            decimal extra = 0;

            if (ddlVariations.SelectedValue != "0")
            {
                string varSql = "SELECT AdditionalPrice FROM ProductVariations WHERE VariationID = @vid";
                object extraObj = DBHelper.ExecuteScalar(varSql, new SqlParameter[] { new SqlParameter("@vid", ddlVariations.SelectedValue) });
                if (extraObj != null && extraObj != DBNull.Value) extra = Convert.ToDecimal(extraObj);
            }
            litPrice.Text = (basePrice + extra).ToString("C");
        }

        private void LoadProductDetails()
        {
            string sql = "SELECT * FROM Products WHERE ProductID = @id AND IsActive = 1";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@id", _productId) });

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                litTitle.Text = row["ProductName"].ToString();
                litProductName.Text = row["ProductName"].ToString();
                litPrice.Text = Convert.ToDecimal(row["Price"]).ToString("C");
                litStock.Text = row["StockQty"].ToString();
                litDesc.Text = row["Description"].ToString().Replace("\n", "<br/>");
                
                string img = row["MainImage"].ToString();
                imgMain.ImageUrl = string.IsNullOrEmpty(img) ? "~/Images/placeholder.png" : img;
                
                int stock = Convert.ToInt32(row["StockQty"]);
                txtQty.Attributes["max"] = stock.ToString();
                
                if (stock <= 0)
                {
                    btnAddToCart.Enabled = false;
                    btnAddToCart.Text = "Out of Stock";
                    btnAddToCart.CssClass = "btn btn-outline";
                }

                // Apple/Amazon-Style Related Products (Frequently Viewed Together)
                int catId = Convert.ToInt32(row["CategoryID"]);
                string relatedSql = "SELECT TOP 4 ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 AND CategoryID = @cid AND ProductID != @pid ORDER BY NEWID()";
                DataTable dtRelated = DBHelper.ExecuteQuery(relatedSql, new SqlParameter[] {
                    new SqlParameter("@cid", catId),
                    new SqlParameter("@pid", _productId)
                });
                rptRelated.DataSource = dtRelated;
                rptRelated.DataBind();

                // Load User Reviews
                string reviewSql = @"
                    SELECT u.FullName, f.Rating, f.Comment, f.FeedbackDate 
                    FROM Feedback f
                    JOIN Users u ON f.UserID = u.UserID 
                    WHERE f.ProductID = @pid
                    ORDER BY f.FeedbackDate DESC";
                DataTable dtReviews = DBHelper.ExecuteQuery(reviewSql, new SqlParameter[] { new SqlParameter("@pid", _productId) });
                
                if (dtReviews.Rows.Count > 0)
                {
                    rptReviews.DataSource = dtReviews;
                    rptReviews.DataBind();
                }
                else
                {
                    lblNoReviews.Visible = true;
                }
                
                if (Session["Role"] != null && Session["Role"].ToString() == "Customer")
                {
                    pnlLeaveReview.Visible = true;
                    pnlLoginToReview.Visible = false;
                }
                else
                {
                    pnlLeaveReview.Visible = false;
                    pnlLoginToReview.Visible = true;
                }
            }
            else
            {
                lblError.Text = "Product is unavailable.";
                lblError.Visible = true;
                pnlDetails.Visible = false;
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20add%20to%20cart.&toastType=info");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            int qty = 1;
            int.TryParse(txtQty.Text, out qty);

            int varId = 0;
            if (pnlVariations.Visible)
            {
                if (ddlVariations.SelectedValue == "0")
                {
                    lblError.Text = "Please select a variation before adding to cart.";
                    lblError.Visible = true;
                    return;
                }
                varId = Convert.ToInt32(ddlVariations.SelectedValue);
            }

            if (qty > 0)
            {
                CartHelper.AddToCart(userId, _productId, qty, varId);
                Response.Redirect("~/Cart.aspx");
            }
        }

        protected void btnWishlist_Click(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20use%20wishlist.&toastType=info");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            string checkSql = "SELECT WishlistID FROM Wishlist WHERE UserID = @uid";
            object widObj = DBHelper.ExecuteScalar(checkSql, new SqlParameter[] { new SqlParameter("@uid", userId) });
            
            int wishlistId = 0;
            if (widObj == null)
            {
                string insertWL = "INSERT INTO Wishlist (UserID) VALUES (@uid); SELECT SCOPE_IDENTITY();";
                wishlistId = Convert.ToInt32(DBHelper.ExecuteScalar(insertWL, new SqlParameter[] { new SqlParameter("@uid", userId) }));
            }
            else
            {
                wishlistId = Convert.ToInt32(widObj);
            }

            string checkItem = "SELECT COUNT(*) FROM WishlistItems WHERE WishlistID = @wid AND ProductID = @pid";
            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkItem, new SqlParameter[] { 
                new SqlParameter("@wid", wishlistId), 
                new SqlParameter("@pid", _productId) 
            }));

            if (count == 0)
            {
                string addItem = "INSERT INTO WishlistItems (WishlistID, ProductID) VALUES (@wid, @pid)";
                DBHelper.ExecuteNonQuery(addItem, new SqlParameter[] { 
                    new SqlParameter("@wid", wishlistId), 
                    new SqlParameter("@pid", _productId) 
                });
            }
            
            ClientScript.RegisterStartupScript(GetType(), "WL", "alert('Added to wishlist!');", true);
            ClientScript.RegisterStartupScript(GetType(), "WL", "alert('Added to wishlist!');", true);
        }

        protected string GenerateStars(object ratingObj)
        {
            if (ratingObj == DBNull.Value || ratingObj == null)
            {
                return "<span style='color:#e2e8f0;'>★★★★★</span>";
            }
            
            int rating = Convert.ToInt32(ratingObj);
            if (rating < 0) rating = 0;
            if (rating > 5) rating = 5;
            
            string filled = new string('★', rating);
            string empty = new string('★', 5 - rating);
            
            return $"{filled}<span style='color:#e2e8f0;'>{empty}</span>";
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20submit%20a%20review.&toastType=info");
                return;
            }

            int rating = 0;
            if (star5.Checked) rating = 5;
            else if (star4.Checked) rating = 4;
            else if (star3.Checked) rating = 3;
            else if (star2.Checked) rating = 2;
            else if (star1.Checked) rating = 1;

            if (rating == 0)
            {
                lblReviewMsg.Text = "Please select a star rating.";
                lblReviewMsg.CssClass = "badge badge-warning mb-3 block";
                lblReviewMsg.Visible = true;
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            // Insert Feedback (OrderID is NULL since they are reviewing directly on the product page)
            string sql = "INSERT INTO Feedback (UserID, ProductID, Rating, Comment, FeedbackDate) VALUES (@uid, @pid, @rat, @com, GETDATE())";
            DBHelper.ExecuteNonQuery(sql, new SqlParameter[] {
                new SqlParameter("@uid", userId),
                new SqlParameter("@pid", _productId),
                new SqlParameter("@rat", rating),
                new SqlParameter("@com", txtReviewComment.Text.Trim())
            });

            // Reload page to show new review
            Response.Redirect("~/ProductDetails.aspx?id=" + _productId);
        }
    }
}
