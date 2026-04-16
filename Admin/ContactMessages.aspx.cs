using System;
using System.Data;
using HimVeda.Classes;

namespace HimVeda.Admin
{
    public partial class ContactMessagesPage : System.Web.UI.Page
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
                LoadData();
            }
        }

        private void LoadData()
        {
            try
            {
                string sql = @"
                    IF OBJECT_ID('dbo.ContactMessages', 'U') IS NULL
                    BEGIN
                        SELECT
                            CAST(NULL AS INT) AS ContactMessageID,
                            CAST(NULL AS NVARCHAR(200)) AS FullName,
                            CAST(NULL AS NVARCHAR(200)) AS Email,
                            CAST(NULL AS NVARCHAR(50)) AS Phone,
                            CAST(NULL AS NVARCHAR(200)) AS Subject,
                            CAST(NULL AS NVARCHAR(MAX)) AS Message,
                            CAST(NULL AS DATETIME) AS SubmittedAt
                        WHERE 1 = 0;
                    END
                    ELSE
                    BEGIN
                    SELECT ContactMessageID, FullName, Email, Phone, Subject, Message, SubmittedAt
                    FROM ContactMessages
                    ORDER BY SubmittedAt DESC;
                    END";

                DataTable dt = DBHelper.ExecuteQuery(sql);
                gvMessages.DataSource = dt;
                gvMessages.DataBind();
                litTotalMessages.Text = dt.Rows.Count.ToString();
            }
            catch
            {
                gvMessages.DataSource = new DataTable();
                gvMessages.DataBind();
                litTotalMessages.Text = "0";
                lblStatus.Visible = true;
                lblStatus.Text = "ContactMessages table not found. Run App_Data/add_contact_messages.sql once.";
                lblStatus.Style["background"] = "#fee2e2";
                lblStatus.Style["color"] = "#991b1b";
            }
        }
    }
}
