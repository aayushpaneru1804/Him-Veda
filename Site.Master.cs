using System;
using System.Web.UI;

namespace HimVeda
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Future auth checking logic can go here for public nav updates
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("~/Products.aspx?search=" + Server.UrlEncode(query));
            }
        }
    }
}
