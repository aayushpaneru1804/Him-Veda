using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Wishlist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20view%20wishlist.&toastType=info");
                return;
            }

            if (!IsPostBack)
            {
                LoadWishlist();
            }
        }

        private void LoadWishlist()
        {
            lblError.Visible = false;
            lblSuccess.Visible = false;

            int userId = Convert.ToInt32(Session["UserID"]);

            string sql = @"
                SELECT w.WishlistID, wi.WishlistItemID, p.ProductID, p.ProductName, p.Price, p.MainImage 
                FROM Wishlist w
                INNER JOIN WishlistItems wi ON w.WishlistID = wi.WishlistID
                INNER JOIN Products p ON wi.ProductID = p.ProductID
                WHERE w.UserID = @uid AND p.IsActive = 1";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@uid", userId) });

            if (dt.Rows.Count > 0)
            {
                rptWishlist.DataSource = dt;
                rptWishlist.DataBind();
                rptWishlist.Visible = true;
                pnlEmpty.Visible = false;
            }
            else
            {
                rptWishlist.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblError.Visible = false;
            lblSuccess.Visible = false;

            if (e.CommandName == "Remove")
            {
                int wishlistItemId = Convert.ToInt32(e.CommandArgument);
                string sql = "DELETE FROM WishlistItems WHERE WishlistItemID = @wid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@wid", wishlistItemId) });
                
                lblSuccess.Text = "Item removed from wishlist.";
                lblSuccess.Visible = true;
                LoadWishlist();
            }
            else if (e.CommandName == "AddCart")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int productId = Convert.ToInt32(args[0]);
                int wishlistItemId = Convert.ToInt32(args[1]);
                int userId = Convert.ToInt32(Session["UserID"]);

                // Add to cart
                CartHelper.AddToCart(userId, productId, 1);

                // Option: Auto-remove from wishlist once added to cart
                string sql = "DELETE FROM WishlistItems WHERE WishlistItemID = @wid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@wid", wishlistItemId) });

                Response.Redirect("~/Cart.aspx");
            }
        }
    }
}
