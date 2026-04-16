using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Vendor
{
    public partial class Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vendor")
            {
                Response.Redirect("~/Login.aspx");
            }

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
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "CategoryName";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));
        }

        private void LoadProducts()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            string sql = @"SELECT p.*, c.CategoryName 
                           FROM Products p 
                           LEFT JOIN Categories c ON p.CategoryID = c.CategoryID 
                           WHERE p.VendorID = @VendorID 
                           ORDER BY p.CreatedAt DESC";
            
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@VendorID", vendorId) });
            gvProducts.DataSource = dt;
            gvProducts.DataBind();
        }

        protected void btnToggleAdd_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = true;
            btnToggleAdd.Visible = false;
            ClearForm();
            lblMessage.Visible = false;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            btnToggleAdd.Visible = true;
            lblMessage.Visible = false;
        }

        private void ClearForm()
        {
            hiddenProductID.Value = "";
            txtProductName.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = "";
            txtStock.Text = "";
            txtDescription.Text = "";
            chkIsActive.Checked = true;
            chkIsFeatured.Checked = false;
            imgPreview.Visible = false;
            btnSave.Text = "Save Product";
            pnlVariations.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Simple validation
            if (string.IsNullOrWhiteSpace(txtProductName.Text) || ddlCategory.SelectedValue == "0" || string.IsNullOrWhiteSpace(txtPrice.Text))
            {
                lblMessage.Text = "Product Name, Category, and Price are required.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            decimal price = 0;
            if (!decimal.TryParse(txtPrice.Text, out price))
            {
                lblMessage.Text = "Invalid price format.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            int stock = 0;
            int.TryParse(txtStock.Text, out stock);

            int vendorId = Convert.ToInt32(Session["VendorID"]);
            string imageUrl = imgPreview.ImageUrl; // Keep existing image by default

            // Handle Image Upload
            if (fuMainImage.HasFile)
            {
                string extension = Path.GetExtension(fuMainImage.FileName).ToLower();
                if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".webp")
                {
                    string dir = Server.MapPath("~/Images/Products/");
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }
                    string fileName = Guid.NewGuid().ToString() + extension;
                    fuMainImage.SaveAs(Path.Combine(dir, fileName));
                    imageUrl = "~/Images/Products/" + fileName;
                }
            }

            if (string.IsNullOrEmpty(hiddenProductID.Value))
            {
                // INSERT
                string sql = @"INSERT INTO Products (VendorID, CategoryID, ProductName, Description, Price, StockQty, MainImage, IsFeatured, IsActive) 
                               VALUES (@Vid, @Cid, @Pname, @Desc, @Price, @Stock, @MainImg, @IsFeat, @IsAct)";
                SqlParameter[] p = new SqlParameter[]
                {
                    new SqlParameter("@Vid", vendorId),
                    new SqlParameter("@Cid", ddlCategory.SelectedValue),
                    new SqlParameter("@Pname", txtProductName.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@MainImg", imageUrl),
                    new SqlParameter("@IsFeat", chkIsFeatured.Checked),
                    new SqlParameter("@IsAct", chkIsActive.Checked)
                };
                DBHelper.ExecuteNonQuery(sql, p);
                lblMessage.Text = "Product added successfully.";
            }
            else
            {
                // UPDATE
                string sql = @"UPDATE Products 
                               SET CategoryID=@Cid, ProductName=@Pname, Description=@Desc, Price=@Price, StockQty=@Stock, MainImage=@MainImg, IsFeatured=@IsFeat, IsActive=@IsAct
                               WHERE ProductID=@Pid AND VendorID=@Vid";
                SqlParameter[] p = new SqlParameter[]
                {
                    new SqlParameter("@Cid", ddlCategory.SelectedValue),
                    new SqlParameter("@Pname", txtProductName.Text.Trim()),
                    new SqlParameter("@Desc", txtDescription.Text.Trim()),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@MainImg", imageUrl),
                    new SqlParameter("@IsFeat", chkIsFeatured.Checked),
                    new SqlParameter("@IsAct", chkIsActive.Checked),
                    new SqlParameter("@Pid", hiddenProductID.Value),
                    new SqlParameter("@Vid", vendorId)
                };
                DBHelper.ExecuteNonQuery(sql, p);
                lblMessage.Text = "Product updated successfully.";
            }

            lblMessage.CssClass = "badge badge-success mb-4";
            lblMessage.Visible = true;
            pnlForm.Visible = false;
            btnToggleAdd.Visible = true;
            LoadProducts();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                int vendorId = Convert.ToInt32(Session["VendorID"]);

                string sql = "SELECT * FROM Products WHERE ProductID = @Pid AND VendorID = @Vid";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] {
                    new SqlParameter("@Pid", productId),
                    new SqlParameter("@Vid", vendorId)
                });

                if (dt.Rows.Count > 0)
                {
                    pnlForm.Visible = true;
                    btnToggleAdd.Visible = false;
                    
                    hiddenProductID.Value = dt.Rows[0]["ProductID"].ToString();
                    txtProductName.Text = dt.Rows[0]["ProductName"].ToString();
                    ddlCategory.SelectedValue = dt.Rows[0]["CategoryID"].ToString();
                    txtPrice.Text = dt.Rows[0]["Price"].ToString();
                    txtStock.Text = dt.Rows[0]["StockQty"].ToString();
                    txtDescription.Text = dt.Rows[0]["Description"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                    chkIsFeatured.Checked = Convert.ToBoolean(dt.Rows[0]["IsFeatured"]);
                    
                    string image = dt.Rows[0]["MainImage"].ToString();
                    if (!string.IsNullOrEmpty(image))
                    {
                        imgPreview.ImageUrl = image;
                        imgPreview.Visible = true;
                    }
                    else
                    {
                        imgPreview.Visible = false;
                    }

                    btnSave.Text = "Update Product";
                    lblMessage.Visible = false;
                    
                    pnlVariations.Visible = true;
                    LoadVariations(productId);
                }
            }
        }

        private void LoadVariations(int productId)
        {
            string sql = "SELECT * FROM ProductVariations WHERE ProductID = @Pid";
            DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@Pid", productId) });
            gvVariations.DataSource = dt;
            gvVariations.DataBind();
        }

        protected void btnAddVariation_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hiddenProductID.Value)) return;
            
            decimal price = 0;
            decimal.TryParse(txtVarPrice.Text, out price);
            
            int stock = 0;
            int.TryParse(txtVarStock.Text, out stock);

            string sql = @"INSERT INTO ProductVariations (ProductID, Size, Color, AdditionalPrice, Stock, SKU) 
                           VALUES (@Pid, @Size, @Color, @Price, @Stock, @SKU)";
            SqlParameter[] p = new SqlParameter[]
            {
                new SqlParameter("@Pid", hiddenProductID.Value),
                new SqlParameter("@Size", string.IsNullOrWhiteSpace(txtVarSize.Text) ? DBNull.Value : (object)txtVarSize.Text.Trim()),
                new SqlParameter("@Color", string.IsNullOrWhiteSpace(txtVarColor.Text) ? DBNull.Value : (object)txtVarColor.Text.Trim()),
                new SqlParameter("@Price", price),
                new SqlParameter("@Stock", stock),
                new SqlParameter("@SKU", string.IsNullOrWhiteSpace(txtVarSKU.Text) ? DBNull.Value : (object)txtVarSKU.Text.Trim())
            };
            
            DBHelper.ExecuteNonQuery(sql, p);
            
            txtVarSize.Text = "";
            txtVarColor.Text = "";
            txtVarPrice.Text = "0";
            txtVarStock.Text = "0";
            txtVarSKU.Text = "";
            
            LoadVariations(Convert.ToInt32(hiddenProductID.Value));
            lblMessage.Text = "Variation added successfully.";
            lblMessage.CssClass = "badge badge-success mb-4";
            lblMessage.Visible = true;
        }

        protected void gvVariations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteVariation")
            {
                int varId = Convert.ToInt32(e.CommandArgument);
                string sql = "DELETE FROM ProductVariations WHERE VariationID = @Vid";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@Vid", varId) });
                
                LoadVariations(Convert.ToInt32(hiddenProductID.Value));
                lblMessage.Text = "Variation removed.";
                lblMessage.CssClass = "badge badge-success mb-4";
                lblMessage.Visible = true;
            }
        }
    }
}
