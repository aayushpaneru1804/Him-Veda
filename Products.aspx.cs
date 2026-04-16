using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class PublicProducts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadProducts();
            }
        }

        private void LoadCategories()
        {
            string sql = "SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1 ORDER BY CategoryName";
            DataTable dt = DBHelper.ExecuteQuery(sql);
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        private void LoadProducts()
        {
            string catId = Request.QueryString["cat"];
            string searchQ = Request.QueryString["search"];
            string sql = "";
            DataTable dt;

            if (!string.IsNullOrEmpty(catId))
            {
                sql = "SELECT ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 AND CategoryID = @cid ORDER BY CreatedAt DESC";
                dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@cid", catId) });
                lblBanner.Text = "Category Products";
            }
            else if (!string.IsNullOrEmpty(searchQ))
            {
                sql = "SELECT ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 AND ProductName LIKE @q ORDER BY CreatedAt DESC";
                dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@q", "%" + searchQ + "%") });
                lblBanner.Text = "Search Results for '" + searchQ + "'";
            }
            else
            {
                sql = "SELECT ProductID, ProductName, Price, MainImage FROM Products WHERE IsActive = 1 ORDER BY CreatedAt DESC";
                dt = DBHelper.ExecuteQuery(sql);
                lblBanner.Text = "All Collection";
            }

            if (dt.Rows.Count > 0)
            {
                rptProducts.DataSource = dt;
                rptProducts.DataBind();
                rptProducts.Visible = true;
                lblEmpty.Visible = false;
            }
            else
            {
                rptProducts.Visible = false;
                lblEmpty.Visible = true;
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20continue.&toastType=info");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            if (e.CommandName == "AddCart")
            {
                CartHelper.AddToCart(userId, productId, 1);
                Response.Redirect("~/Cart.aspx");
            }
            else if (e.CommandName == "AddWishlist")
            {
                // Simple wishlist add logic
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

                // Append to WishlistItems
                string checkItem = "SELECT COUNT(*) FROM WishlistItems WHERE WishlistID = @wid AND ProductID = @pid";
                int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkItem, new SqlParameter[] { 
                    new SqlParameter("@wid", wishlistId), 
                    new SqlParameter("@pid", productId) 
                }));

                if (count == 0)
                {
                    string addItem = "INSERT INTO WishlistItems (WishlistID, ProductID) VALUES (@wid, @pid)";
                    DBHelper.ExecuteNonQuery(addItem, new SqlParameter[] { 
                        new SqlParameter("@wid", wishlistId), 
                        new SqlParameter("@pid", productId) 
                    });
                }
                
                // Show an alert or redirect
                ClientScript.RegisterStartupScript(GetType(), "WishlistAlert", "alert('Added to wishlist!');", true);
            }
        }
    }
}
