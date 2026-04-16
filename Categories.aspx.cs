using System;
using System.Data;
using System.Web;
using HimVeda.Classes;

namespace HimVeda
{
    public partial class PublicCategories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        /// <summary>Resolves category image URL for Repeater binding; empty returns null for "no image" UI.</summary>
        protected string ResolveCategoryImage(object categoryImage)
        {
            if (categoryImage == null || ReferenceEquals(categoryImage, DBNull.Value))
                return null;
            string s = categoryImage.ToString().Trim();
            return string.IsNullOrEmpty(s) ? null : VirtualPathUtility.ToAbsolute(s);
        }

        private void LoadData()
        {
            string sql = "SELECT CategoryID, CategoryName, Description, CategoryImage FROM Categories WHERE IsActive = 1 ORDER BY CategoryName";
            DataTable dt;
            try
            {
                dt = DBHelper.ExecuteQuery(sql);
            }
            catch
            {
                // Fallback for older DB schema where CategoryImage does not exist yet.
                string fallbackSql = "SELECT CategoryID, CategoryName, Description FROM Categories WHERE IsActive = 1 ORDER BY CategoryName";
                dt = DBHelper.ExecuteQuery(fallbackSql);
                dt.Columns.Add("CategoryImage", typeof(string));
            }

            if (dt.Rows.Count > 0)
            {
                rptCategories.DataSource = dt;
                rptCategories.DataBind();
                rptCategories.Visible = true;
                lblEmpty.Visible = false;
            }
            else
            {
                rptCategories.Visible = false;
                lblEmpty.Visible = true;
            }
        }
    }
}
