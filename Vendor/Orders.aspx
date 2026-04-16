<%@ Page Title="Customer Orders" Language="C#" MasterPageFile="~/Vendor/Vendor.master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="HimVeda.Vendor.OrdersPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .data-table { width: 100%; border-collapse: collapse; margin-top: 1rem; background: white; border-radius: var(--border-radius); overflow: hidden; box-shadow: var(--shadow-sm); }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background-color: #f8fafc; color: #475569; font-weight: 600; }
        .data-table tr:hover { background-color: #f8fafc; }
        
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 15px; margin-bottom: 2rem; border: 1px solid #f1f5f9; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        
        .badge-pending { background: #fef08a; color: #854d0e; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-shipped { background: #bae6fd; color: #0369a1; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
        .badge-delivered { background: #dcfce7; color: #166534; padding: 0.3rem 0.8rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-boxes-packing"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Orders</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></h2>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#dcfce7; color:#166534;"><i class="fa-solid fa-money-bill-wave"></i></div>
            <div>
                <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Revenue</h4>
                <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalRevenue" runat="server">Rs. 0</asp:Literal></h2>
            </div>
        </div>
    </div>

    <div class="card" style="padding: 1.5rem; width: 100%;">
        <h3>Recent Customer Orders</h3>
        <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;" />
        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="data-table" GridLines="None" DataKeyNames="OrderItemID" OnRowCommand="gvOrders_RowCommand">
            <Columns>
                <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                <asp:BoundField DataField="SubTotal" HeaderText="Total Revenue" DataFormatString="{0:C}" />
                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                <asp:TemplateField HeaderText="Status / Action">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" style="width: auto; display: inline-block; padding: 0.2rem;" SelectedValue='<%# Eval("OrderStatus") %>'>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Processing">Processing</asp:ListItem>
                            <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                            <asp:ListItem Value="Delivered" Enabled="false">Delivered</asp:ListItem>
                        </asp:DropDownList>
                        <asp:LinkButton ID="btnUpdateStatus" runat="server" CommandName="UpdateStatus" CommandArgument='<%# Eval("OrderItemID") %>' CssClass="btn btn-outline" style="padding: 0.2rem 0.5rem; font-size: 0.8rem; margin-left: 0.5rem;">Update</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
