using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class ProductsPage : System.Web.UI.Page
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
                LoadDropdowns();
                LoadData();
            }
        }

        private void LoadDropdowns()
        {
            DataTable vendors = DBHelper.ExecuteQuery(
                "SELECT VendorID, BusinessName, VendorName FROM Vendors ORDER BY BusinessName");
            ddlVendor.DataSource = vendors;
            ddlVendor.DataTextField = "BusinessName";
            ddlVendor.DataValueField = "VendorID";
            ddlVendor.DataBind();
            ddlVendor.Items.Insert(0, new ListItem("-- Select vendor --", "0"));

            DataTable categories = DBHelper.ExecuteQuery(
                "SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1 ORDER BY CategoryName");
            ddlCategory.DataSource = categories;
            ddlCategory.DataTextField = "CategoryName";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("-- Select category --", "0"));
        }

        private void LoadData()
        {
            string sql = @"
                SELECT p.ProductID, p.ProductName, p.Price, p.StockQty, p.MainImage, 
                       c.CategoryName, v.VendorName 
                FROM Products p
                LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                LEFT JOIN Vendors v ON p.VendorID = v.VendorID
                ORDER BY p.ProductID DESC";
            
            DataTable dt = DBHelper.ExecuteQuery(sql);
            gvProducts.DataSource = dt;
            gvProducts.DataBind();
        }

        private string SaveUploadedProductImage()
        {
            if (!fuProductImage.HasFile)
                return null;

            string ext = Path.GetExtension(fuProductImage.FileName).ToLowerInvariant();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                return string.Empty;

            string dir = Server.MapPath("~/Images/Products/");
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);

            string fileName = Guid.NewGuid().ToString("N") + ext;
            fuProductImage.SaveAs(Path.Combine(dir, fileName));
            return "~/Images/Products/" + fileName;
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtProductName.Text) || ddlVendor.SelectedValue == "0" || ddlCategory.SelectedValue == "0" || string.IsNullOrWhiteSpace(txtPrice.Text))
            {
                ShowMessage("Product name, vendor, category, and price are required.", false);
                return;
            }

            if (!decimal.TryParse(txtPrice.Text, out decimal price))
            {
                ShowMessage("Invalid price.", false);
                return;
            }

            int.TryParse(txtStock.Text, out int stock);

            string uploadedImage = SaveUploadedProductImage();
            if (uploadedImage == string.Empty)
            {
                ShowMessage("Please upload a JPG, PNG, or WebP image.", false);
                return;
            }

            string desc = txtDescription.Text.Trim();
            if (string.IsNullOrEmpty(desc))
                desc = " ";

            bool isEdit = !string.IsNullOrEmpty(hiddenProductID.Value);
            string mainImage = uploadedImage ?? hiddenExistingMainImage.Value;
            if (string.IsNullOrWhiteSpace(mainImage))
                mainImage = null;

            string sql;
            SqlParameter[] p;
            if (!isEdit)
            {
                sql = @"INSERT INTO Products (VendorID, CategoryID, ProductName, Description, Price, StockQty, MainImage, IsFeatured, IsActive) 
                        VALUES (@Vid, @Cid, @Pname, @Desc, @Price, @Stock, @MainImg, @IsFeat, @IsAct)";
                p = new SqlParameter[]
                {
                    new SqlParameter("@Vid", ddlVendor.SelectedValue),
                    new SqlParameter("@Cid", ddlCategory.SelectedValue),
                    new SqlParameter("@Pname", txtProductName.Text.Trim()),
                    new SqlParameter("@Desc", desc),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@MainImg", string.IsNullOrEmpty(mainImage) ? (object)DBNull.Value : mainImage),
                    new SqlParameter("@IsFeat", chkFeatured.Checked),
                    new SqlParameter("@IsAct", chkActive.Checked)
                };
            }
            else
            {
                sql = @"UPDATE Products
                        SET VendorID=@Vid, CategoryID=@Cid, ProductName=@Pname, Description=@Desc, Price=@Price, StockQty=@Stock, MainImage=@MainImg, IsFeatured=@IsFeat, IsActive=@IsAct
                        WHERE ProductID=@Pid";
                p = new SqlParameter[]
                {
                    new SqlParameter("@Vid", ddlVendor.SelectedValue),
                    new SqlParameter("@Cid", ddlCategory.SelectedValue),
                    new SqlParameter("@Pname", txtProductName.Text.Trim()),
                    new SqlParameter("@Desc", desc),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@MainImg", string.IsNullOrEmpty(mainImage) ? (object)DBNull.Value : mainImage),
                    new SqlParameter("@IsFeat", chkFeatured.Checked),
                    new SqlParameter("@IsAct", chkActive.Checked),
                    new SqlParameter("@Pid", hiddenProductID.Value)
                };
            }

            DBHelper.ExecuteNonQuery(sql, p);
            ShowMessage(isEdit ? "Product updated successfully." : "Product added successfully.", true);
            ClearProductForm();
            LoadData();
        }

        protected void btnClearProductForm_Click(object sender, EventArgs e)
        {
            ClearProductForm();
        }

        private void ClearProductForm()
        {
            txtProductName.Text = "";
            ddlVendor.SelectedIndex = 0;
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = "";
            txtStock.Text = "";
            txtDescription.Text = "";
            chkFeatured.Checked = false;
            chkActive.Checked = true;
            hiddenProductID.Value = "";
            hiddenExistingMainImage.Value = "";
            imgProductPreview.ImageUrl = "";
            imgProductPreview.Visible = false;
            btnAddProduct.Text = "Add product";
        }

        private void ShowMessage(string text, bool success)
        {
            lblMessage.Text = text;
            lblMessage.Visible = true;
            if (success)
            {
                lblMessage.Style["background"] = "#dcfce7";
                lblMessage.Style["color"] = "#166534";
            }
            else
            {
                lblMessage.Style["background"] = "#fef3c7";
                lblMessage.Style["color"] = "#92400e";
            }
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                string sql = "SELECT * FROM Products WHERE ProductID=@id";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@id", id) });
                if (dt.Rows.Count == 0)
                {
                    ShowMessage("Product not found.", false);
                    return;
                }

                DataRow r = dt.Rows[0];
                hiddenProductID.Value = r["ProductID"].ToString();
                ddlVendor.SelectedValue = r["VendorID"].ToString();
                ddlCategory.SelectedValue = r["CategoryID"].ToString();
                txtProductName.Text = r["ProductName"].ToString();
                txtPrice.Text = Convert.ToDecimal(r["Price"]).ToString("0.##");
                txtStock.Text = r["StockQty"].ToString();
                txtDescription.Text = r["Description"].ToString();
                chkFeatured.Checked = Convert.ToBoolean(r["IsFeatured"]);
                chkActive.Checked = Convert.ToBoolean(r["IsActive"]);

                string image = r["MainImage"] == DBNull.Value ? "" : r["MainImage"].ToString();
                hiddenExistingMainImage.Value = image;
                imgProductPreview.ImageUrl = image;
                imgProductPreview.Visible = !string.IsNullOrEmpty(image);
                btnAddProduct.Text = "Update product";

                ShowMessage("Edit mode enabled for selected product.", true);
            }
            else if (e.CommandName == "DeleteProduct")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                
                DBHelper.ExecuteNonQuery("DELETE FROM CartItems WHERE ProductID = @id", new SqlParameter[] { new SqlParameter("@id", id) });
                DBHelper.ExecuteNonQuery("DELETE FROM WishlistItems WHERE ProductID = @id", new SqlParameter[] { new SqlParameter("@id", id) });
                DBHelper.ExecuteNonQuery("DELETE FROM Feedback WHERE ProductID = @id", new SqlParameter[] { new SqlParameter("@id", id) });
                
                string sql = "DELETE FROM Products WHERE ProductID = @id";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@id", id) });
                
                lblMessage.Text = "Product completely deleted.";
                lblMessage.Style["background"] = "#fee2e2";
                lblMessage.Style["color"] = "#991b1b";
                lblMessage.Visible = true;
                LoadData();
            }
        }
    }
}
