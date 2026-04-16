using System;
using System.Data;
using System.Data.SqlClient;

namespace HimVeda.Classes
{
    public static class CartHelper
    {
        public static void AddToCart(int userId, int productId, int quantity, int variationId = 0)
        {
            // 1. Get or Create active Cart for User
            int cartId = GetActiveCartId(userId);

            // 2. Get Product Price (including Variation's additional price)
            decimal unitPrice = 0;
            string getPriceSql = "SELECT Price FROM Products WHERE ProductID = @pid";
            object priceObj = DBHelper.ExecuteScalar(getPriceSql, new SqlParameter[] { new SqlParameter("@pid", productId) });
            if (priceObj != null && priceObj != DBNull.Value)
            {
                unitPrice = Convert.ToDecimal(priceObj);
            }

            if (variationId > 0)
            {
                string varSql = "SELECT AdditionalPrice FROM ProductVariations WHERE VariationID = @vid";
                object varObj = DBHelper.ExecuteScalar(varSql, new SqlParameter[] { new SqlParameter("@vid", variationId) });
                if (varObj != null && varObj != DBNull.Value)
                {
                    unitPrice += Convert.ToDecimal(varObj);
                }
            }

            // 3. Check if Product+Variation already in CartItems
            string checkItemSql = "SELECT CartItemID, Quantity FROM CartItems WHERE CartID = @cid AND ProductID = @pid AND ISNULL(VariationID, 0) = @vid";
            DataTable dtItem = DBHelper.ExecuteQuery(checkItemSql, new SqlParameter[] { 
                new SqlParameter("@cid", cartId), 
                new SqlParameter("@pid", productId),
                new SqlParameter("@vid", variationId)
            });

            if (dtItem.Rows.Count > 0)
            {
                // Update existing CartItem
                int currentQty = Convert.ToInt32(dtItem.Rows[0]["Quantity"]);
                int cartItemId = Convert.ToInt32(dtItem.Rows[0]["CartItemID"]);
                int newQty = currentQty + quantity;
                decimal newSubTotal = newQty * unitPrice;

                string updateSql = "UPDATE CartItems SET Quantity = @qty, SubTotal = @sub WHERE CartItemID = @id";
                DBHelper.ExecuteNonQuery(updateSql, new SqlParameter[]
                {
                    new SqlParameter("@qty", newQty),
                    new SqlParameter("@sub", newSubTotal),
                    new SqlParameter("@id", cartItemId)
                });
            }
            else
            {
                // Insert new CartItem
                decimal subTotal = quantity * unitPrice;
                string insertSql = "INSERT INTO CartItems (CartID, ProductID, Quantity, UnitPrice, SubTotal, VariationID) VALUES (@cid, @pid, @qty, @uprice, @sub, @vid)";
                DBHelper.ExecuteNonQuery(insertSql, new SqlParameter[]
                {
                    new SqlParameter("@cid", cartId),
                    new SqlParameter("@pid", productId),
                    new SqlParameter("@qty", quantity),
                    new SqlParameter("@uprice", unitPrice),
                    new SqlParameter("@sub", subTotal),
                    new SqlParameter("@vid", variationId > 0 ? (object)variationId : DBNull.Value)
                });
            }
        }

        private static int GetActiveCartId(int userId)
        {
            string checkCartSql = "SELECT CartID FROM Cart WHERE UserID = @uid AND CartStatus = 'Active'";
            object cartObj = DBHelper.ExecuteScalar(checkCartSql, new SqlParameter[] { new SqlParameter("@uid", userId) });

            if (cartObj != null)
            {
                return Convert.ToInt32(cartObj);
            }
            else
            {
                // Create new Cart and return Scope Identity
                string createCartSql = "INSERT INTO Cart (UserID, CartStatus) VALUES (@uid, 'Active'); SELECT SCOPE_IDENTITY();";
                object newCartObj = DBHelper.ExecuteScalar(createCartSql, new SqlParameter[] { new SqlParameter("@uid", userId) });
                return Convert.ToInt32(newCartObj);
            }
        }
    }
}
