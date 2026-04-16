using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class Categories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            string sql = "SELECT * FROM Categories ORDER BY CategoryName";
            DataTable dt = DBHelper.ExecuteQuery(sql);

            // Backward compatibility: if DB migration hasn't been run yet,
            // add a virtual CategoryImage column so data binding doesn't crash.
            if (!dt.Columns.Contains("CategoryImage"))
            {
                dt.Columns.Add("CategoryImage", typeof(string));
            }

            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }

        /// <summary>
        /// Safely get CategoryImage value from a repeater data item (DataRowView or object).
        /// Returns an empty string when the value is missing or null.
        /// </summary>
        protected string GetCategoryImage(object dataItem)
        {
            try
            {
                if (dataItem == null) return string.Empty;

                var drv = dataItem as DataRowView;
                if (drv != null)
                {
                    if (drv.Row.Table.Columns.Contains("CategoryImage") && drv["CategoryImage"] != DBNull.Value)
                        return drv["CategoryImage"].ToString();
                    return string.Empty;
                }

                var row = dataItem as DataRow;
                if (row != null)
                {
                    if (row.Table.Columns.Contains("CategoryImage") && row["CategoryImage"] != DBNull.Value)
                        return row["CategoryImage"].ToString();
                    return string.Empty;
                }

                // Fallback: try DataBinder.Eval
                var val = System.Web.UI.DataBinder.Eval(dataItem, "CategoryImage");
                return val != null ? val.ToString() : string.Empty;
            }
            catch
            {
                return string.Empty;
            }
        }

        private string SaveUploadedCategoryImage()
        {
            if (!fuCategoryImage.HasFile)
                return null;

            string extension = Path.GetExtension(fuCategoryImage.FileName).ToLowerInvariant();
            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".webp")
                return null;

            string dir = Server.MapPath("~/Images/Categories/");
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);

            string fileName = Guid.NewGuid().ToString("N") + extension;
            fuCategoryImage.SaveAs(Path.Combine(dir, fileName));
            return "~/Images/Categories/" + fileName;
        }

        private bool HasCategoryImageColumn()
        {
            object exists = DBHelper.ExecuteScalar(@"
                SELECT COUNT(*) 
                FROM sys.columns 
                WHERE object_id = OBJECT_ID('dbo.Categories') 
                  AND name = 'CategoryImage'");
            return Convert.ToInt32(exists) > 0;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtCatName.Text))
            {
                lblMessage.Text = "Category Name is required.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            string catName = txtCatName.Text.Trim();
            string description = txtDescription.Text.Trim();
            bool isActive = chkIsActive.Checked;

            string newImagePath = SaveUploadedCategoryImage();
            if (fuCategoryImage.HasFile && newImagePath == null)
            {
                lblMessage.Text = "Please upload a JPG, PNG, or WebP image.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            bool supportsCategoryImage = HasCategoryImageColumn();

            if (string.IsNullOrEmpty(hiddenCategoryID.Value))
            {
                // INSERT
                if (supportsCategoryImage)
                {
                    string sql = "INSERT INTO Categories (CategoryName, Description, CategoryImage, IsActive) VALUES (@Name, @Desc, @Img, @IsActive)";
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", catName),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description),
                        new SqlParameter("@Img", string.IsNullOrEmpty(newImagePath) ? (object)DBNull.Value : newImagePath),
                        new SqlParameter("@IsActive", isActive)
                    };
                    DBHelper.ExecuteNonQuery(sql, parameters);
                    lblMessage.Text = "Category added successfully.";
                }
                else
                {
                    string sql = "INSERT INTO Categories (CategoryName, Description, IsActive) VALUES (@Name, @Desc, @IsActive)";
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", catName),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description),
                        new SqlParameter("@IsActive", isActive)
                    };
                    DBHelper.ExecuteNonQuery(sql, parameters);
                    lblMessage.Text = "Category added. Run App_Data/add_category_image.sql to enable category image saving.";
                    lblMessage.CssClass = "badge badge-warning mb-4";
                }
            }
            else
            {
                string imageValue = newImagePath ?? hiddenExistingCategoryImage.Value;
                if (string.IsNullOrWhiteSpace(imageValue))
                    imageValue = null;

                // UPDATE
                if (supportsCategoryImage)
                {
                    string sql = "UPDATE Categories SET CategoryName=@Name, Description=@Desc, CategoryImage=@Img, IsActive=@IsActive WHERE CategoryID=@ID";
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", catName),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description),
                        new SqlParameter("@Img", string.IsNullOrEmpty(imageValue) ? (object)DBNull.Value : imageValue),
                        new SqlParameter("@IsActive", isActive),
                        new SqlParameter("@ID", hiddenCategoryID.Value)
                    };
                    DBHelper.ExecuteNonQuery(sql, parameters);
                    lblMessage.Text = "Category updated successfully.";
                }
                else
                {
                    string sql = "UPDATE Categories SET CategoryName=@Name, Description=@Desc, IsActive=@IsActive WHERE CategoryID=@ID";
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", catName),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description),
                        new SqlParameter("@IsActive", isActive),
                        new SqlParameter("@ID", hiddenCategoryID.Value)
                    };
                    DBHelper.ExecuteNonQuery(sql, parameters);
                    lblMessage.Text = "Category updated. Run App_Data/add_category_image.sql to enable category image saving.";
                    lblMessage.CssClass = "badge badge-warning mb-4";
                }
            }

            if (!lblMessage.CssClass.Contains("badge-warning"))
            {
                lblMessage.CssClass = "badge badge-success mb-4";
            }
            lblMessage.Visible = true;
            btnClear_Click(null, null);
            LoadCategories();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtCatName.Text = "";
            txtDescription.Text = "";
            chkIsActive.Checked = true;
            hiddenCategoryID.Value = "";
            hiddenExistingCategoryImage.Value = "";
            imgCategoryPreview.Visible = false;
            imgCategoryPreview.ImageUrl = "";
            btnSave.Text = "Save Category";
        }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int categoryID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                string sql = "SELECT * FROM Categories WHERE CategoryID = @ID";
                DataTable dt = DBHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@ID", categoryID) });
                if (dt.Rows.Count > 0)
                {
                    txtCatName.Text = dt.Rows[0]["CategoryName"].ToString();
                    txtDescription.Text = dt.Rows[0]["Description"] != DBNull.Value ? dt.Rows[0]["Description"].ToString() : "";
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                    hiddenCategoryID.Value = categoryID.ToString();
                    btnSave.Text = "Update Category";

                    string img = dt.Rows[0].Table.Columns.Contains("CategoryImage") && dt.Rows[0]["CategoryImage"] != DBNull.Value
                        ? dt.Rows[0]["CategoryImage"].ToString()
                        : "";
                    hiddenExistingCategoryImage.Value = img;
                    if (!string.IsNullOrEmpty(img))
                    {
                        imgCategoryPreview.ImageUrl = img;
                        imgCategoryPreview.Visible = true;
                    }
                    else
                    {
                        imgCategoryPreview.Visible = false;
                        imgCategoryPreview.ImageUrl = "";
                    }
                }
            }
            else if (e.CommandName == "Delete")
            {
                // Soft delete by setting IsActive = false so products don't break
                string sql = "UPDATE Categories SET IsActive = 0 WHERE CategoryID = @ID";
                DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@ID", categoryID) });
                lblMessage.Text = "Category deactivated.";
                lblMessage.CssClass = "badge badge-success mb-4";
                lblMessage.Visible = true;
                LoadCategories();
            }
        }
    }
}
