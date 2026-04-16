using System;
using System.Data;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx?toast=Please%20login%20to%20continue.&toastType=info", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadSummary();
                LoadUserAddress();
            }
        }

        private void LoadUserAddress()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string sql = "SELECT Address, City, PostalCode FROM Users WHERE UserID = @uid";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@uid", userId) });
            
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["Address"] != DBNull.Value) txtAddress.Text = dt.Rows[0]["Address"].ToString();
                if (dt.Rows[0]["City"] != DBNull.Value) txtCity.Text = dt.Rows[0]["City"].ToString();
                if (dt.Rows[0]["PostalCode"] != DBNull.Value) txtPostal.Text = dt.Rows[0]["PostalCode"].ToString();
            }
        }

        private void LoadSummary()
        {
            // First check if cart has items
            int userId = Convert.ToInt32(Session["UserID"]);
            string checkCartSql = @"
                SELECT COUNT(*) FROM CartItems ci 
                INNER JOIN Cart c ON ci.CartID = c.CartID 
                WHERE c.UserID = @uid AND c.CartStatus = 'Active'";
            
            int count = Convert.ToInt32(DBHelper.ExecuteScalar(checkCartSql, new SqlParameter[] { new SqlParameter("@uid", userId) }));
            if (count == 0 && !pnlSuccess.Visible)
            {
                Response.Redirect("~/Cart.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (Session["CartTotal"] != null && Session["CartSubtotal"] != null)
            {
                decimal subtotal = Convert.ToDecimal(Session["CartSubtotal"]);
                decimal total = Convert.ToDecimal(Session["CartTotal"]);
                decimal discount = Session["DiscountAmount"] != null ? Convert.ToDecimal(Session["DiscountAmount"]) : 0;

                litSubTotal.Text = subtotal.ToString("C");
                litTotal.Text = total.ToString("C");

                if (discount > 0)
                {
                    pnlDiscount.Visible = true;
                    litDiscount.Text = discount.ToString("C");
                    litCouponCode.Text = Session["CouponCode"] != null ? Session["CouponCode"].ToString() : "";
                }
            }
            else
            {
                Response.Redirect("~/Cart.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAddress.Text) || string.IsNullOrWhiteSpace(txtCity.Text))
            {
                lblError.Text = "Please provide your full shipping address and city.";
                lblError.Visible = true;
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            decimal totalAmount = Convert.ToDecimal(Session["CartTotal"]);
            decimal discount = Session["DiscountAmount"] != null ? Convert.ToDecimal(Session["DiscountAmount"]) : 0;
            object couponId = Session["CouponID"] ?? DBNull.Value;
            
            string paymentMethod = rbCOD.Checked ? "Cash on Delivery" : "Online";
            string paymentStatus = rbCOD.Checked ? "Pending" : "Completed"; // Simulating online pay success
            string fullAddress = $"{txtAddress.Text.Trim()}, {txtCity.Text.Trim()} - {txtPostal.Text.Trim()}";

            // 1. Get Active Cart Items
            string sqlCart = "SELECT ci.*, p.VendorID, p.StockQty, p.ProductName FROM CartItems ci INNER JOIN Cart c ON ci.CartID = c.CartID INNER JOIN Products p ON ci.ProductID = p.ProductID WHERE c.UserID = @uid AND c.CartStatus = 'Active'";
            DataTable dtItems = DBHelper.ExecuteQuery(sqlCart, new SqlParameter[] { new SqlParameter("@uid", userId) });

            if (dtItems.Rows.Count == 0) return;

            // 2. Verify Stock availability
            foreach (DataRow row in dtItems.Rows)
            {
                int qty = Convert.ToInt32(row["Quantity"]);
                int stock = Convert.ToInt32(row["StockQty"]);
                if (qty > stock)
                {
                    lblError.Text = $"Sorry, '{row["ProductName"]}' does not have enough stock. Available: {stock}. Please adjust your cart.";
                    lblError.Visible = true;
                    return;
                }
            }

            try
            {
                // 3. Create Order
                string insertOrderSql = @"
                    INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, CouponID, DiscountAmount, PaymentMethod, PaymentStatus) 
                    VALUES (@uid, @tot, @addr, @cid, @disc, @pm, @pstat); 
                    SELECT SCOPE_IDENTITY();";
                
                SqlParameter[] orderParams = new SqlParameter[] {
                    new SqlParameter("@uid", userId),
                    new SqlParameter("@tot", totalAmount),
                    new SqlParameter("@addr", fullAddress),
                    new SqlParameter("@cid", couponId),
                    new SqlParameter("@disc", discount),
                    new SqlParameter("@pm", paymentMethod),
                    new SqlParameter("@pstat", paymentStatus)
                };

                object orderIdObj = DBHelper.ExecuteScalar(insertOrderSql, orderParams);
                if (orderIdObj == null || orderIdObj == DBNull.Value)
                {
                    lblError.Text = "Order creation failed. Please try again.";
                    lblError.Visible = true;
                    return;
                }
                int orderId = Convert.ToInt32(orderIdObj);

                // 4. Create OrderItems & Update Stock
                int cartId = 0;
                foreach (DataRow row in dtItems.Rows)
                {
                    cartId = GetRequiredInt(row, "CartID");
                    int productId = GetRequiredInt(row, "ProductID");
                    int qty = GetRequiredInt(row, "Quantity");
                    decimal unitPrice = GetRequiredDecimal(row, "UnitPrice");
                    decimal subTotal = GetRequiredDecimal(row, "SubTotal");
                    object vendorParam = DBNull.Value;
                    object vendorObj = row["VendorID"];
                    if (vendorObj != DBNull.Value)
                    {
                        vendorParam = Convert.ToInt32(vendorObj);
                    }
                    object variationParam = DBNull.Value;
                    if (dtItems.Columns.Contains("VariationID"))
                    {
                        object variationObj = row["VariationID"];
                        if (variationObj != DBNull.Value)
                        {
                            variationParam = Convert.ToInt32(variationObj);
                        }
                    }

                    // Insert OrderItem
                    string itemSql = "INSERT INTO OrderItems (OrderID, ProductID, VendorID, Quantity, UnitPrice, SubTotal, VariationID) VALUES (@oid, @pid, @vid, @qty, @up, @sub, @varid)";
                    DBHelper.ExecuteNonQuery(itemSql, new SqlParameter[] {
                        new SqlParameter("@oid", orderId), new SqlParameter("@pid", productId), new SqlParameter("@vid", vendorParam),
                        new SqlParameter("@qty", qty), new SqlParameter("@up", unitPrice), new SqlParameter("@sub", subTotal),
                        new SqlParameter("@varid", variationParam)
                    });

                    // Deduct Stock
                    string stockSql = "UPDATE Products SET StockQty = StockQty - @qty WHERE ProductID = @pid";
                    DBHelper.ExecuteNonQuery(stockSql, new SqlParameter[] { new SqlParameter("@qty", qty), new SqlParameter("@pid", productId) });
                }

                // 5. Create Payment Record
                string paySql = "INSERT INTO Payments (OrderID, PaymentMethod, Amount, PaymentStatus) VALUES (@oid, @pm, @amt, @pstat)";
                DBHelper.ExecuteNonQuery(paySql, new SqlParameter[] {
                    new SqlParameter("@oid", orderId), new SqlParameter("@pm", paymentMethod), new SqlParameter("@amt", totalAmount), new SqlParameter("@pstat", paymentStatus)
                });

                // 6. Create Delivery Tracking Record (Pending Default)
                string delSql = "INSERT INTO DeliveryTracking (OrderID) VALUES (@oid)";
                DBHelper.ExecuteNonQuery(delSql, new SqlParameter[] { new SqlParameter("@oid", orderId) });

                // 7. Update Cart Status to Ordered
                string cartUpdSql = "UPDATE Cart SET CartStatus = 'Ordered' WHERE CartID = @cid";
                DBHelper.ExecuteNonQuery(cartUpdSql, new SqlParameter[] { new SqlParameter("@cid", cartId) });

                // Save address to user profile if empty
                string updAddress = "UPDATE Users SET Address = ISNULL(Address, @addr), City = ISNULL(City, @city), PostalCode = ISNULL(PostalCode, @post) WHERE UserID = @uid";
                DBHelper.ExecuteNonQuery(updAddress, new SqlParameter[] {
                    new SqlParameter("@addr", txtAddress.Text.Trim()), new SqlParameter("@city", txtCity.Text.Trim()), new SqlParameter("@post", txtPostal.Text.Trim()), new SqlParameter("@uid", userId)
                });

                // Success View
                // Clear session dependencies
                Session["CartSubtotal"] = null;
                Session["CartTotal"] = null;
                Session["DiscountAmount"] = null;
                Session["CouponID"] = null;
                Session["CouponCode"] = null;

                Response.Redirect("~/OrderHistory.aspx?toast=Order%20placed%20successfully!&toastType=success", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            catch(Exception ex)
            {
                lblError.Text = "An error occurred during checkout processing: " + ex.Message;
                lblError.Visible = true;
            }
        }

        private static int GetRequiredInt(DataRow row, string columnName)
        {
            object value = row[columnName];
            if (value == null || value == DBNull.Value)
            {
                throw new Exception($"Missing required value: {columnName}.");
            }
            return Convert.ToInt32(value);
        }

        private static decimal GetRequiredDecimal(DataRow row, string columnName)
        {
            object value = row[columnName];
            if (value == null || value == DBNull.Value)
            {
                throw new Exception($"Missing required value: {columnName}.");
            }
            return Convert.ToDecimal(value);
        }
    }
}
