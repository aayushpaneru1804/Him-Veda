using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;

namespace HimVeda.Vendor
{
    public partial class Settings : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["HimVedaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vendor")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadSettings();
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            using (SqlConnection con = new SqlConnection(connString))
            {
                string script = "SELECT ProductName, StockQty FROM Products WHERE VendorID = @VendorID ORDER BY ProductName";
                using (SqlCommand cmd = new SqlCommand(script, con))
                {
                    cmd.Parameters.AddWithValue("@VendorID", vendorId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            rptProducts.DataSource = reader;
                            rptProducts.DataBind();
                            pnlNoProducts.Visible = false;
                        }
                        else
                        {
                            pnlNoProducts.Visible = true;
                        }
                    }
                }
            }
        }

        private void LoadSettings()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            using (SqlConnection con = new SqlConnection(connString))
            {
                string script = "SELECT StoreLogo, StoreDescription, PaymentInfo FROM Vendors WHERE VendorID = @VendorID";
                using (SqlCommand cmd = new SqlCommand(script, con))
                {
                    cmd.Parameters.AddWithValue("@VendorID", vendorId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtStoreLogo.Text = reader["StoreLogo"] != DBNull.Value ? reader["StoreLogo"].ToString() : "";
                            txtDescription.Text = reader["StoreDescription"] != DBNull.Value ? reader["StoreDescription"].ToString() : "";
                            txtPaymentInfo.Text = reader["PaymentInfo"] != DBNull.Value ? reader["PaymentInfo"].ToString() : "";
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            using (SqlConnection con = new SqlConnection(connString))
            {
                string script = "UPDATE Vendors SET StoreLogo = @StoreLogo, StoreDescription = @StoreDescription, PaymentInfo = @PaymentInfo WHERE VendorID = @VendorID";
                using (SqlCommand cmd = new SqlCommand(script, con))
                {
                    cmd.Parameters.AddWithValue("@StoreLogo", string.IsNullOrWhiteSpace(txtStoreLogo.Text) ? DBNull.Value : (object)txtStoreLogo.Text);
                    cmd.Parameters.AddWithValue("@StoreDescription", string.IsNullOrWhiteSpace(txtDescription.Text) ? DBNull.Value : (object)txtDescription.Text);
                    cmd.Parameters.AddWithValue("@PaymentInfo", string.IsNullOrWhiteSpace(txtPaymentInfo.Text) ? DBNull.Value : (object)txtPaymentInfo.Text);
                    cmd.Parameters.AddWithValue("@VendorID", vendorId);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    lblMessage.Text = "Settings saved successfully.";
                    lblMessage.BackColor = ColorTranslator.FromHtml("#d1fae5");
                    lblMessage.ForeColor = ColorTranslator.FromHtml("#10b981");
                    lblMessage.Visible = true;
                }
            }
        }
    }
}
