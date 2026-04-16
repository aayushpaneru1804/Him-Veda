<%@ Page Title="Vendor Dashboard" Language="C#" MasterPageFile="~/Vendor/Vendor.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="HimVeda.Vendor.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: white; border-radius: var(--border-radius); padding: 1.5rem; display: flex; align-items: center; gap: 1.5rem; box-shadow: var(--shadow-sm); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-icon { font-size: 2.5rem; color: var(--primary-color); background: var(--secondary-color); width: 80px; height: 80px; display: flex; justify-content: center; align-items: center; border-radius: 50%; }
        .stat-info h3 { font-size: 1rem; color: var(--text-muted); margin-bottom: 0.5rem; font-weight: 500; }
        .stat-number { font-size: 1.8rem; font-weight: 700; color: var(--text-main); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div style="margin-bottom: 2rem;">
        <h2><i class="fa-solid fa-chart-pie mr-2"></i> Welcome back, <asp:Literal ID="litVendorName" runat="server"></asp:Literal>!</h2>
        <p style="color: var(--text-muted);">Here's an overview of your store's performance today.</p>
    </div>

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-boxes-stacked"></i></div>
            <div class="stat-info">
                <h3>Total Products</h3>
                <div class="stat-number"><asp:Literal ID="litTotalProducts" runat="server">0</asp:Literal></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-cart-arrow-down"></i></div>
            <div class="stat-info">
                <h3>Total Orders</h3>
                <div class="stat-number"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-money-bill-trend-up"></i></div>
            <div class="stat-info">
                <h3>Total Revenue</h3>
                <div class="stat-number"><asp:Literal ID="litTotalRevenue" runat="server">Rs 0.00</asp:Literal></div>
            </div>
        </div>
    </div>

    <!-- Quick action links -->
    <div class="card" style="padding: 1.5rem;">
        <h3>Quick Actions</h3>
        <p style="color: var(--text-muted); margin-bottom: 1.5rem;">Manage your store efficiently.</p>
        
        <div class="flex gap-2">
            <a href="Products.aspx" class="btn btn-primary"><i class="fa-solid fa-plus-circle mr-2"></i> Add New Product</a>
            <a href="Orders.aspx" class="btn btn-outline"><i class="fa-solid fa-truck-fast mr-2"></i> View Pending Orders</a>
        </div>
    </div>
</asp:Content>
