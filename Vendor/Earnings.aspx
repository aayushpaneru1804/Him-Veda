<%@ Page Title="Earnings & Payouts" Language="C#" MasterPageFile="~/Vendor/Vendor.master" AutoEventWireup="true" CodeBehind="Earnings.aspx.cs" Inherits="HimVeda.Vendor.Earnings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .data-table { width: 100%; border-collapse: collapse; margin-top: 1rem; background: white; border-radius: var(--border-radius); overflow: hidden; box-shadow: var(--shadow-sm); }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background-color: #f8fafc; color: #475569; font-weight: 600; }
        .data-table tr:hover { background-color: #f8fafc; }
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; display: flex; align-items: center; justify-content: space-between; margin-bottom: 2rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><i class="fa-solid fa-wallet text-primary mr-2"></i> Earnings & Payouts</h2>
    <p style="color: var(--text-muted); margin-bottom: 2rem;">Manage your store revenues and request withdrawals.</p>

    <asp:Label ID="lblMessage" runat="server" CssClass="badge badge-success mb-4" style="display:block; padding: 1rem; border-radius:4px;" Visible="false"></asp:Label>

    <div class="stat-card">
        <div>
            <h4 style="margin:0; color:#64748b; font-size:1rem; margin-bottom: 0.5rem;">Available Wallet Balance</h4>
            <h2 style="margin:0; color:#1e293b; font-size:2.5rem;"><asp:Literal ID="litWalletBalance" runat="server">Rs 0.00</asp:Literal></h2>
            <small style="color: var(--text-muted);">Net revenue minus platform commissions (<asp:Literal ID="litCommission" runat="server"></asp:Literal>% commission rate applies).</small>
        </div>
        <div>
            <div style="margin-bottom: 1rem;">
                <label class="form-label" style="display:block;">Withdrawal Amount</label>
                <asp:TextBox ID="txtWithdrawAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01" style="width: 200px; display:inline-block;"></asp:TextBox>
            </div>
            <asp:Button ID="btnRequestWithdrawal" runat="server" Text="Request Withdrawal" CssClass="btn btn-primary" OnClick="btnRequestWithdrawal_Click" />
        </div>
    </div>

    <div class="card" style="padding: 1.5rem; width: 100%;">
        <h3>Withdrawal History</h3>
        <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
        <asp:GridView ID="gvWithdrawals" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="WithdrawalID" HeaderText="Trans ID" />
                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                <asp:BoundField DataField="RequestedAt" HeaderText="Requested" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="badge" style="background:#f1f5f9; color:#475569; padding: 0.3rem 0.8rem; border-radius:50px; font-weight:600;"><%# Eval("Status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ProcessedAt" HeaderText="Processed" DataFormatString="{0:MMM dd, yyyy}" NullDisplayText="-" />
            </Columns>
            <EmptyDataTemplate>
                <div style="text-align:center; padding: 2rem; color: #94a3b8;">
                    No withdrawal requests yet.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
