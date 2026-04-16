<%@ Page Title="Store Settings" Language="C#" MasterPageFile="~/Vendor/Vendor.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="HimVeda.Vendor.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Store Settings
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .settings-grid { display: grid; grid-template-columns: 1fr; gap: 2rem; align-items: start; }
        @media (min-width: 992px) { .settings-grid { grid-template-columns: 1fr 1fr; } }
        .form-label { font-weight: 600; color: #334155; margin-bottom: 0.5rem; display: block; font-size: 0.95rem; }
        .form-control { width: 100%; padding: 0.8rem 1rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 1rem; margin-bottom: 1.5rem; transition: border-color 0.2s, box-shadow 0.2s; background: #f8fafc; }
        .form-control:focus { border-color: #52B788; outline: none; box-shadow: 0 0 0 3px rgba(82, 183, 136, 0.2); background: white; }
        .card-title { font-size: 1.4rem; font-weight: 700; color: #1B4332; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem; }
        .card-subtitle { color: #64748b; margin-bottom: 2rem; font-size: 0.95rem; }
        .save-btn { width: 100%; padding: 1rem; font-size: 1.1rem; border-radius: 8px; font-weight: 600; box-shadow: 0 4px 6px -1px rgba(82, 183, 136, 0.2); margin-top: 1rem; }
        .inventory-table { width: 100%; border-collapse: collapse; }
        .inventory-table th { background: #f1f5f9; padding: 1rem; font-weight: 600; color: #475569; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
        .inventory-table td { padding: 1rem; border-bottom: 1px solid #f1f5f9; font-size: 0.95rem; color: #1e293b; }
        .inventory-row:hover td { background: #f8fafc; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="settings-grid">
        <!-- Profile Settings Card -->
        <div class="card" style="padding: 2.5rem; border-radius: 16px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9;">
            <h2 class="card-title"><i class="fa-solid fa-store"></i> Store Profile Setup</h2>
            <p class="card-subtitle">Personalize how customers perceive your business.</p>
            
            <asp:Label ID="lblMessage" runat="server" style="display:block; padding: 1rem; margin-bottom: 1.5rem; border-radius: 8px; font-weight: 500;" Visible="false"></asp:Label>

            <div class="form-group">
                <label class="form-label">Store Logo URL</label>
                <asp:TextBox ID="txtStoreLogo" runat="server" CssClass="form-control" placeholder="https://example.com/my-logo.png"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">About Your Store</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Share your unique brand story, values, and what makes your organic products special..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Payout Information (Bank/UPI)</label>
                <asp:TextBox ID="txtPaymentInfo" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Provide accurate bank transfer details or UPI IDs for platform disbursements..."></asp:TextBox>
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Save Configuration" CssClass="btn btn-primary save-btn" OnClick="btnSave_Click" />
        </div>

        <!-- Inventory Summary Card -->
        <div class="card" style="padding: 2.5rem; border-radius: 16px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; display: flex; flex-direction: column;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem;">
                <div>
                    <h2 class="card-title"><i class="fa-solid fa-boxes-stacked"></i> Live Inventory</h2>
                    <p class="card-subtitle" style="margin-bottom: 0;">Real-time overview of your product stock.</p>
                </div>
                <a href="Products.aspx" class="btn btn-outline" style="padding: 0.5rem 1rem; border-radius: 50px; font-size: 0.9rem;">Manage</a>
            </div>

            <div style="background: white; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; max-height: 550px; overflow-y: auto;">
                <table class="inventory-table">
                    <thead>
                        <tr>
                            <th style="text-align: left;">Product Nomenclature</th>
                            <th style="text-align: right;">Units Available</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptProducts" runat="server">
                            <ItemTemplate>
                                <tr class="inventory-row">
                                    <td style="font-weight: 500;"><%# Eval("ProductName") %></td>
                                    <td style="text-align: right; font-weight: 700; color: <%# Convert.ToInt32(Eval("StockQty")) > 5 ? "#10b981" : (Convert.ToInt32(Eval("StockQty")) > 0 ? "#f59e0b" : "#ef4444") %>;">
                                        <%# Convert.ToInt32(Eval("StockQty")) == 0 ? "Out of Stock" : Eval("StockQty").ToString() %>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
                <asp:Panel ID="pnlNoProducts" runat="server" Visible="false" style="padding: 3rem; text-align: center;">
                    <i class="fa-solid fa-box-open" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
                    <h4 style="color: #64748b; margin: 0; font-weight: 500;">No products mapped.</h4>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
