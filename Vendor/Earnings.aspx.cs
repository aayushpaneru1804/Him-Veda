using System;
using System.Data;
using System.Data.SqlClient;
using HimVeda.Classes;

namespace HimVeda.Vendor
{
    public partial class Earnings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Vendor")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CalculateAndUpdateWallet();
                LoadEarningsAndHistory();
            }
        }

        private void CalculateAndUpdateWallet()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            
            // 1. Get Commission Rate
            string rateSql = "SELECT SettingValue FROM PlatformSettings WHERE SettingKey = 'CommissionRate'";
            object rateObj = DBHelper.ExecuteScalar(rateSql);
            decimal commissionRate = rateObj != null ? Convert.ToDecimal(rateObj) : 10;
            litCommission.Text = commissionRate.ToString("0.##");

            // 2. Calculate Gross Sales from Orders (Assumes all orders for simplicity)
            string grossSql = "SELECT ISNULL(SUM(SubTotal), 0) FROM OrderItems WHERE VendorID = @vid";
            decimal grossSales = Convert.ToDecimal(DBHelper.ExecuteScalar(grossSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) }));

            // 3. Subtract Commission
            decimal netSales = grossSales * (1 - (commissionRate / 100));

            // 4. Subtract Requested/Processed Withdrawals
            string withdrawnSql = "SELECT ISNULL(SUM(Amount), 0) FROM Withdrawals WHERE VendorID = @vid";
            decimal withdrawn = Convert.ToDecimal(DBHelper.ExecuteScalar(withdrawnSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) }));

            decimal currentWallet = netSales - withdrawn;
            if (currentWallet < 0) currentWallet = 0;

            // Optional: Update Vendors table WalletBalance just to keep it in sync
            string updateWallet = "UPDATE Vendors SET WalletBalance = @bal WHERE VendorID = @vid";
            DBHelper.ExecuteNonQuery(updateWallet, new SqlParameter[] { new SqlParameter("@bal", currentWallet), new SqlParameter("@vid", vendorId) });
        }

        private void LoadEarningsAndHistory()
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            
            // Load Wallet Balance
            string balSql = "SELECT WalletBalance FROM Vendors WHERE VendorID = @vid";
            object balObj = DBHelper.ExecuteScalar(balSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) });
            decimal balance = balObj != null && balObj != DBNull.Value ? Convert.ToDecimal(balObj) : 0;
            
            litWalletBalance.Text = balance.ToString("C");

            // Load Withdrawals
            string histSql = "SELECT * FROM Withdrawals WHERE VendorID = @vid ORDER BY RequestedAt DESC";
            DataTable dt = DBHelper.ExecuteQuery(histSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) });
            gvWithdrawals.DataSource = dt;
            gvWithdrawals.DataBind();
        }

        protected void btnRequestWithdrawal_Click(object sender, EventArgs e)
        {
            int vendorId = Convert.ToInt32(Session["VendorID"]);
            decimal amount = 0;
            if (!decimal.TryParse(txtWithdrawAmount.Text, out amount) || amount <= 0)
            {
                lblMessage.Text = "Please enter a valid amount greater than 0.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            // Check if they have enough balance
            string balSql = "SELECT WalletBalance FROM Vendors WHERE VendorID = @vid";
            object balObj = DBHelper.ExecuteScalar(balSql, new SqlParameter[] { new SqlParameter("@vid", vendorId) });
            decimal balance = balObj != null && balObj != DBNull.Value ? Convert.ToDecimal(balObj) : 0;

            if (amount > balance)
            {
                lblMessage.Text = "Insufficient wallet balance.";
                lblMessage.CssClass = "badge badge-warning mb-4";
                lblMessage.Visible = true;
                return;
            }

            // Create Withdrawal Request
            string sql = "INSERT INTO Withdrawals (VendorID, Amount, Status) VALUES (@vid, @amt, 'Pending')";
            DBHelper.ExecuteNonQuery(sql, new SqlParameter[] { new SqlParameter("@vid", vendorId), new SqlParameter("@amt", amount) });

            txtWithdrawAmount.Text = "";
            CalculateAndUpdateWallet();
            LoadEarningsAndHistory();

            lblMessage.Text = "Withdrawal requested successfully.";
            lblMessage.CssClass = "badge badge-success mb-4";
            lblMessage.Visible = true;
        }
    }
}
