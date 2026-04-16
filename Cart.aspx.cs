using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class CartPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20view%20your%20cart.&toastType=info", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        private void LoadCart()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string sql = @"
                SELECT ci.CartItemID, ci.Quantity, ci.UnitPrice, ci.SubTotal, p.ProductID, p.ProductName, p.MainImage 
                FROM CartItems ci
                INNER JOIN Cart c ON ci.CartID = c.CartID
                INNER JOIN Products p ON ci.ProductID = p.ProductID
                WHERE c.UserID = @uid AND c.CartStatus = 'Active'
            ";

            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@uid", userId) });

            if (dt.Rows.Count > 0)
            {
                rptCart.DataSource = dt;
                rptCart.DataBind();
                
                decimal subtotal = 0;
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["SubTotal"]);
                }

                litSubTotal.Text = subtotal.ToString("C");
                
                decimal discount = Session["DiscountAmount"] != null ? Convert.ToDecimal(Session["DiscountAmount"]) : 0;
                
                if (discount > 0)
                {
                    litDiscount.Text = discount.ToString("C");
                    lblDiscountName.Text = Session["CouponCode"] != null ? Session["CouponCode"].ToString() : "";
                }
                else
                {
                    litDiscount.Text = "Rs 0.00";
                    lblDiscountName.Text = "";
                }

                decimal total = subtotal - discount;
                if (total < 0) total = 0;
                litTotal.Text = total.ToString("C");

                pnlCart.Visible = true;
                pnlEmpty.Visible = false;
                
                Session["CartSubtotal"] = subtotal;
                Session["CartTotal"] = total;
            }
            else
            {
                pnlCart.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveItem")
            {
                int cartItemId = Convert.ToInt32(e.CommandArgument);
                string deleteSql = "DELETE FROM CartItems WHERE CartItemID = @id";
                DBHelper.ExecuteNonQuery(deleteSql, new SqlParameter[] { new SqlParameter("@id", cartItemId) });
                
                lblMessage.Text = "Item removed from cart.";
                lblMessage.CssClass = "badge badge-success mb-4";
                lblMessage.Visible = true;
                LoadCart();
            }
            else if (e.CommandName == "UpdateQty")
            {
                int cartItemId = Convert.ToInt32(e.CommandArgument);
                RepeaterItem row = e.Item;
                
                TextBox txtQty = (TextBox)row.FindControl("txtGridQty");
                
                int qty = 1;
                int.TryParse(txtQty.Text, out qty);
                if (qty < 1) qty = 1;

                string updateSql = "UPDATE CartItems SET Quantity = @qty, SubTotal = UnitPrice * @qty WHERE CartItemID = @id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[] { 
                    new SqlParameter("@qty", qty),
                    new SqlParameter("@id", cartItemId)
                });

                lblMessage.Text = "Cart updated successfully.";
                lblMessage.CssClass = "badge badge-success mb-4";
                lblMessage.Visible = true;
                LoadCart();
            }
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim();
            if (string.IsNullOrEmpty(code)) return;

            string checkSql = "SELECT * FROM Coupons WHERE Code = @code AND IsActive = 1 AND EndDate >= GETDATE() AND StartDate <= GETDATE()";
            DataTable dt = DBHelper.ExecuteQuery(checkSql, new SqlParameter[] { new SqlParameter("@code", code) });

            if (dt.Rows.Count > 0)
            {
                DataRow cRow = dt.Rows[0];
                decimal minOrder = Convert.ToDecimal(cRow["MinOrderAmount"]);
                decimal currentSubtotal = Session["CartSubtotal"] != null ? Convert.ToDecimal(Session["CartSubtotal"]) : 0;

                if (currentSubtotal < minOrder)
                {
                    lblCouponMsg.Text = "Minimum order amount for this coupon is " + minOrder.ToString("C");
                    lblCouponMsg.ForeColor = System.Drawing.Color.Red;
                    lblCouponMsg.Visible = true;
                    return;
                }

                string type = cRow["DiscountType"].ToString();
                decimal val = Convert.ToDecimal(cRow["DiscountValue"]);
                decimal computedDiscount = 0;

                if (type == "Percentage")
                {
                    computedDiscount = currentSubtotal * (val / 100);
                }
                else
                {
                    computedDiscount = val;
                }

                Session["DiscountAmount"] = computedDiscount;
                Session["CouponID"] = cRow["CouponID"];
                Session["CouponCode"] = code;

                lblCouponMsg.Text = "Coupon applied!";
                lblCouponMsg.ForeColor = System.Drawing.Color.Green;
                lblCouponMsg.Visible = true;
                
                LoadCart();
            }
            else
            {
                lblCouponMsg.Text = "Invalid or expired coupon.";
                lblCouponMsg.ForeColor = System.Drawing.Color.Red;
                lblCouponMsg.Visible = true;
                Session["DiscountAmount"] = null;
                Session["CouponID"] = null;
                Session["CouponCode"] = null;
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Redirect to Checkout page
            Response.Redirect("~/Checkout.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
